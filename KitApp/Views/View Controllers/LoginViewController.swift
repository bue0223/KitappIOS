//
//  ViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 6/29/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController, ViewControllerInterface {
    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet weak var benefitVideoButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var tradeButton: UIButton!
    @IBOutlet weak var priceProgramButton: UIButton!
    
    @IBOutlet weak var darkOverlayView: UIView!
    
    @IBOutlet weak var downloadingContainerView: UIView!
    
    @IBOutlet weak var downloadProgressView: UIView!
    
    @IBOutlet weak var downloadProgressWidthConstraint: NSLayoutConstraint!
    
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        setupButtons()
    }
    
    func setupButtons(buttons: [UIButton]) {
        for button in buttons {
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 4.0
            button.layer.shadowOffset = CGSize.zero // Use any CGSize
            button.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.start()
        enableButtons = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetProperties()
        
        view.isUserInteractionEnabled = true
    }
    
    func initView() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ButtonTableViewCell.self)
        tableView.register(RadioButtonTableViewCell.self)
        tableView.register(TextFieldTableViewCell.self)
        tableView.register(ImageTableViewCell.self)
        registerForKeyboardWillShowNotification(tableView)
        registerForKeyboardWillHideNotification(tableView)
        
        setupButtons(buttons: [benefitVideoButton, priceProgramButton, priceButton, tradeButton])
    }
    
    var enableButtons: Bool = false {
        didSet {
            setupButtons()
        }
    }
    
    func setupButtons() {
        if enableButtons == false {
            benefitVideoButton.alpha = 0.50
            tradeButton.alpha = 0.50
            priceButton.alpha = 0.50
            priceProgramButton.alpha = 0.50
            
            benefitVideoButton.isUserInteractionEnabled = false
            tradeButton.isUserInteractionEnabled = false
            priceButton.isUserInteractionEnabled = false
            priceProgramButton.isUserInteractionEnabled = false
        }else {
            benefitVideoButton.alpha = 1.0
            tradeButton.alpha = viewModel.selectedDropDownItemForUsertype.value != "VSM Luzon" ? 1.0 : 0.50
            priceButton.alpha = 1.0
            priceProgramButton.alpha = 1.0
            
            benefitVideoButton.isUserInteractionEnabled = true
            tradeButton.isUserInteractionEnabled = viewModel.selectedDropDownItemForUsertype.value != "VSM Luzon"
            priceButton.isUserInteractionEnabled = true
            
                        let items: [PriceProgramItemEntity] = (CoreDataManager().fetch(isPriceProgram: true) ?? []).filter { (priceProgramEntity) -> Bool in
                            
                            // NOTE: TO update
                             return priceProgramEntity.ownerType == "wholesaler"
            //                return priceProgramEntity.ownerType == UserManager().user?.userType
                        }
                        let item = items.first
                     
            priceProgramButton.alpha = item?.is_shown == 1 ? 1 : 0.50
            priceProgramButton.isUserInteractionEnabled = item?.is_shown == 1
        }
    }
    
    func initBinding() {
        viewModel.sectionViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
            self?.tableView.reloadData()
        }
        
        viewModel.proceed = {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "LoginToPhotoCaptureSegue", sender: nil)
        }
        
        viewModel.isLoading.addObserver(fireNow: false) { (isLoading) in
            if isLoading == true {
                self.view.isUserInteractionEnabled = false
                SVProgressHUD.show()
            }else {
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
            }
        }
        
        viewModel.presentPopUpWithTransaction = { transaction in
            self.presentPopup(popupType: .needsInternet) {
                self.viewModel.updateData()
            }
        }
        
        
        viewModel.openDropDownView = {
            self.performSegue(withIdentifier: "LoginToDropDown", sender: nil)
        }
        
        viewModel.enableButtons.addObserver(fireNow: false) { (isEnabled) in
            self.enableButtons = isEnabled
        }
        
        viewModel.proceedProductsPriceList = {
            SVProgressHUD.dismiss()
            self.viewModel.createUser()
            self.performSegue(withIdentifier: "LoginToPriceDisplaySegue", sender: nil)
        }
        
        viewModel.proceedTradePrograms = {
            SVProgressHUD.dismiss()
            self.viewModel.createUser()
            self.performSegue(withIdentifier: "LoginToTradeSegue", sender: nil)
        }
        
        viewModel.proceedBenefitVideo = {
            SVProgressHUD.dismiss()
            self.viewModel.createUser()
            self.performSegue(withIdentifier: "LoginToBenefitSegue", sender: nil)
        }
        
        
        DownloadManager.shared.completedDownloading = {
            self.view.isUserInteractionEnabled = true
            self.showDownloading(progress: 100.0)
            self.hideDownloading()
        }
        
        
        DownloadManager.shared.downloadingProgress = { progress in
            self.showDownloading(progress: progress)
        }
        
        DownloadManager.shared.promptsUserForUpdateOption = {
            
            if SessionManager.shared.loadChangeIdentifier() == nil {
                self.presentPopup(popupType: .needsForceUpdateData) {
                    if self.viewModel.isConnectedToInternet == false {
                        self.viewModel.presentPopUpWithTransaction? {
                            DownloadManager.shared.startDownload()
                            self.view.isUserInteractionEnabled = false
                            self.showDownloading()
                        }
                        
                        return
                    }
                    
                    DownloadManager.shared.startDownload()
                    self.view.isUserInteractionEnabled = false

                    self.showDownloading()
                }
            }else {
                self.presentPopup(popupType: .needsUpdate) {
                    
                    if self.viewModel.isConnectedToInternet == false {
                        self.viewModel.presentPopUpWithTransaction? {
                            DownloadManager.shared.startDownload()
                            self.view.isUserInteractionEnabled = false
                            self.showDownloading()
                        }
                        
                        return
                    }
                    
                    DownloadManager.shared.startDownload()
                    self.view.isUserInteractionEnabled = false
                    
                    self.showDownloading()
                }
            }
            

        }
        
       // viewModel.start()
    }
    
    func showDownloading(progress: Double = 0.0) {
        darkOverlayView.isHidden = false
        downloadingContainerView.isHidden = false
        downloadProgressWidthConstraint.constant = CGFloat(739 * (progress / 100))
    }
    
    func hideDownloading() {
        darkOverlayView.isHidden = true
        downloadingContainerView.isHidden = true
        downloadProgressWidthConstraint.constant = 0
    }
    
    func resetProperties() {
        viewModel.shouldProceedPricelist = false
        viewModel.shouldProceedTradePrograms = false
        viewModel.shouldProceedLogin = false
        viewModel.shouldProceedBenefitVideo = false
    }
    
    
    func formatNumber(_ number: Double) -> String? {

       let formatter = NumberFormatter()
       formatter.minimumFractionDigits = 2 // minimum number of fraction digits on right
       formatter.maximumFractionDigits = 2 // maximum number of fraction digits on right, or comment for all available
       formatter.minimumIntegerDigits = 0 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)

       let formattedNumber = formatter.string(from: NSNumber.init(value: number))

       return formattedNumber

    }
    
    @IBAction func benefitVideoButtonPressed(_ sender: RoundButton) {
        viewModel.benefitVideoButtonPressed?()
    }
    
    @IBAction func priceButtonPressed(_ sender: RoundButton) {
        viewModel.productsButtonPressed?()
    }
    
    @IBAction func tradeButtonPressed(_ sender: RoundButton) {
        viewModel.tradeProgramsButtonPressed?()
    }
    
    @IBAction func priceProgramButtonPressed(_ sender: Any) {

        //viewModel.isLoading.value = true
        //ContentManager().getPriceProgram(downloadCompleted: {
            self.viewModel.createUser()
            //self.viewModel.isLoading.value = false
            self.performSegue(withIdentifier: "LoginToPsspSegue", sender: nil)
        //})
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dropVc = segue.destination as? DropDownViewController {
            dropVc.dataSource = viewModel.userCategories
            dropVc.cellPressed = { index in
                self.viewModel.selectedDropDownIndex?(index)
            }
        }
        
        if let priceVc = segue.destination as? PriceDisplayViewController {
            priceVc.viewModel.userType = viewModel.inputs[.ownerType] == "retailer" ? .retailer : .wholeSaler
                     
        }
        
        if let vc = segue.destination as? PsspViewController {
            vc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
        }
        
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionViewModel = viewModel.sectionViewModels.value[section]
        return sectionViewModel.rowViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier(for: rowViewModel), for: indexPath)
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowViewModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]
        
        return CGFloat(rowViewModel.rowHeight)
    }
}


extension NSLayoutConstraint {
/**
 Change multiplier constraint

 - parameter multiplier: CGFloat
 - returns: NSLayoutConstraint
*/
func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {

    NSLayoutConstraint.deactivate([self])

    let newConstraint = NSLayoutConstraint(
        item: firstItem,
        attribute: firstAttribute,
        relatedBy: relation,
        toItem: secondItem,
        attribute: secondAttribute,
        multiplier: multiplier,
        constant: constant)

    newConstraint.priority = priority
    newConstraint.shouldBeArchived = self.shouldBeArchived
    newConstraint.identifier = self.identifier

    NSLayoutConstraint.activate([newConstraint])
    return newConstraint
}

}
