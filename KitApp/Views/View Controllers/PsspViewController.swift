//
//  PsspViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class PsspViewController: UIViewController, ViewControllerInterface, AudioPlayerController {
     var player: AVAudioPlayer?
    

    lazy var viewModel: PsspViewModel = {
        return PsspViewModel()
    }()
    @IBOutlet weak var psspAnimationImageView: UIImageView!
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
        
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()
    
    lazy var bottomNavigationViewModel: BottomNavigationViewModel =  {
        return BottomNavigationViewModel()
    }()

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initAnimation()
        playAudioFile(resource: "money-coins-in-hand")
    }
    
    func initView() {
        //view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(PsspHeaderTableViewCell.self)
        tableView.register(PsspItemTableViewCell.self)
        registerForKeyboardWillShowNotification(tableView)
        registerForKeyboardWillHideNotification(tableView)
        
        headerView.setup(viewModel: headerViewModel)
        bottomNavigationView.setup(viewModel: bottomNavigationViewModel)
        
        psspAnimationImageView.image = UIImage(named: "pssp-1")
    }
    
    func initAnimation() {
        psspAnimationImageView.animationImages = animatedImages(for: "pssp")
        psspAnimationImageView.animationDuration = 0.5
        psspAnimationImageView.animationRepeatCount = 10000
        psspAnimationImageView.startAnimating()
    }

    
    func initBinding() {
        viewModel.sectionViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
            self?.tableView.reloadData()
        }
        
        viewModel.proceed = {
            //self.viewModel.isLoading.value = true
            
            let items: [PriceProgramItemEntity] = (CoreDataManager().fetch(isPriceProgram: true) ?? []).filter { (priceProgramEntity) -> Bool in
                
                // NOTE: TO update
                 return priceProgramEntity.ownerType == "wholesaler"
//                return priceProgramEntity.ownerType == UserManager().user?.userType
            }
            let item = items.first
            
            if item?.is_shown == 1 {
                self.performSegue(withIdentifier: "PsspToPriceProgramSegue", sender: nil)
            }else {
                if UserManager().user?.isVsmLuzonUser == true {
                    self.performSegue(withIdentifier: "PsspToPriceDisplaySegue", sender: nil)
                }else {
                    self.performSegue(withIdentifier: "PsspToTradeProgramSegue", sender: nil)
                }
            }
            

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
        
        bottomNavigationViewModel.backButtonPressed = {
            self.navigationController?.popViewController(animated: true)
        }
        
        bottomNavigationViewModel.nextButtonPressed = {
            //self.viewModel.validate()
            self.viewModel.proceed?()
            
        }
        
        
        headerViewModel.logoButtonPressed = {
            self.presentPopup(okButtonHandler: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        
        viewModel.start()
    }
    
    func animatedImages(for name: String) -> [UIImage] {
        
        var i = 1
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let priceVc = segue.destination as? PriceDisplayViewController {
            priceVc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
        }
    }
}

extension PsspViewController: UITableViewDelegate, UITableViewDataSource {
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

