//
//  InputViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SVProgressHUD

enum UserType {
    case retailer
    case wholeSaler
}

class InputViewController: UIViewController, ViewControllerInterface{
    
    lazy var viewModel: InputViewModel = {
        return InputViewModel()
    }()

    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var secondTableView: UITableView!
    
    @IBOutlet weak var thirdTableView: UITableView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var headerView: HeaderView!
    
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()
    
    
    // MARK: Off take view properties
    
    @IBOutlet weak var offtakeComputeContainerView: UIView!
    
    
    @IBOutlet weak var offtakePmftcLabel: UILabel!
    
    @IBOutlet weak var offtakeOthersLabel: UILabel!
    
    @IBOutlet weak var offtakeTotalCigarsLabel: UILabel!
    
    @IBOutlet weak var profitPmftcLabel: UILabel!
    
    @IBOutlet weak var profitOthersLabel: UILabel!
    
    @IBOutlet weak var profitTotalCigarsLabel: UILabel!
    
    // MARK: Rewards view properties
    
    @IBOutlet weak var rewardsComputeContainerView: UIView!
    
    
    @IBOutlet weak var rewardsTotalLabel: UILabel!
    
    @IBOutlet weak var rewardsPmftcLabel: UILabel!
    
    @IBOutlet weak var rewardsOthersLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -320 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func initView() {
        let tableViews = [firstTableView, secondTableView, thirdTableView]
        
        view.backgroundColor = .white
        for tableView in tableViews {
            if let tableView = tableView {
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.allowsSelection = false
                tableView.register(ButtonTableViewCell.self)
                tableView.register(RadioButtonTableViewCell.self)
                tableView.register(AutoComputeTextFieldTableViewCell.self)
                tableView.register(TextFieldTableViewCell.self)
                tableView.register(ImageTableViewCell.self)
                tableView.register(VerticalAlignLabelTemplateTableViewCell.self)
                tableView.register(TitleWithSubTitleTemplateTableViewCell.self)
                //registerForKeyboardWillShowNotification(tableView)
               // registerForKeyboardWillHideNotification(tableView)
            }
        }
        
        headerView.setup(viewModel: headerViewModel)
        
        view.bringSubviewToFront(viewModel.inputType == .offtake ? offtakeComputeContainerView : rewardsComputeContainerView)
    }

    func initBinding() {
        let tableViews = [firstTableView, secondTableView, thirdTableView]
        
        viewModel.updatesTopHeaderText = { text in
            self.topLabel.text = text
        }
        
        viewModel.tableViewModels.addObserver(fireNow: false) { (sectionViewModels) in
            for tableView in tableViews {
                tableView?.reloadData()
            }
        }
        
        viewModel.proceed = {
            if self.viewModel.inputType == .offtake {
                if let user = UserManager().user {
                    user.totalPmtcProfit = self.viewModel.totalProfitPmftc
                    user.totalOthersProfit = self.viewModel.totalProfitOthers
                    
                    UserManager().setUser(user: user)
                }
            }
            
            if self.viewModel.inputType == .rewards {
                if let user = UserManager().user {
                    user.totalPmtcRewards = self.viewModel.pmftcRewardsTotal
                    user.totalOthersRewards = self.viewModel.othersRewardsTotal
                    
                    UserManager().setUser(user: user)
                }
            }
            
            if self.viewModel.inputType == .rewards {
                self.performSegue(withIdentifier: "InputToDisplayPriceSegue", sender: nil)
            }else {
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
                    vc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
                    vc.viewModel.inputType = .rewards
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        
        viewModel.isUpdatingValue.addObserver(fireNow: false) { (isUpdating) in
            if isUpdating == true {
                
                // MARK: OFF TAKE
                self.offtakePmftcLabel.text = "\(self.viewModel.totalOffTakePmftc)"
                self.profitPmftcLabel.text = "\(self.viewModel.totalProfitPmftc.formattedAmount)"
                
                self.offtakeOthersLabel.text = "\(self.viewModel.totalOffTakerOthers)"
                self.profitOthersLabel.text = "\(self.viewModel.totalProfitOthers.formattedAmount)"
                
                self.offtakeTotalCigarsLabel.text = "\(self.viewModel.totalCigarettes)"
                self.profitTotalCigarsLabel.text = "\(self.viewModel.totalProfit.formattedAmount)"
                
                // MARK: Rewards
                self.rewardsTotalLabel.text = "\(self.viewModel.rewardsTotal.formattedAmount)"
                self.rewardsPmftcLabel.text = "\(self.viewModel.pmftcRewardsTotal.formattedAmount)"
                
                self.rewardsOthersLabel.text = "\(self.viewModel.othersRewardsTotal.formattedAmount)"
            }
        }
        
        viewModel.start()
        viewModel.fetch()
        
        headerViewModel.logoButtonPressed = {
            self.presentPopup(okButtonHandler: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PriceViewController {
            vc.viewModel.userType = viewModel.userType
           // vc.totalPmftcProfit = viewModel.totalProfitPmftc
           // vc.totalOtherBrandsProfit = viewModel.totalProfitOthers
        }
    }
    
    @IBAction func leftButtonNavigationPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightButtonNavigationPressed(_ sender: UIButton) {
        self.viewModel.validate()
    }
    
}

extension InputViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let tableViewModel: TableViewConfigurable = viewModel.getTableViewModel(tag: tableView.tag)
        
        return tableViewModel.sectionViewModels.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewModel: TableViewConfigurable = viewModel.getTableViewModel(tag: tableView.tag)
        
        let sectionViewModel = tableViewModel.sectionViewModels.value[section]
        return sectionViewModel.rowViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewModel: TableViewConfigurable = viewModel.getTableViewModel(tag: tableView.tag)
        
        let sectionViewModel = tableViewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier(for: rowViewModel), for: indexPath)

        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowViewModel)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewModel: TableViewConfigurable = viewModel.getTableViewModel(tag: tableView.tag)
        
        let sectionViewModel = tableViewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]
    
        return CGFloat(rowViewModel.rowHeight)
    }
}
