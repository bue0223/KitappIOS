//
//  PriceProgramViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation

class PriceProgramViewController: UIViewController, ViewControllerInterface, AudioPlayerController {
    var player: AVAudioPlayer?
    
    lazy var viewModel: PriceProgramViewModel = {
        return PriceProgramViewModel()
    }()
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    @IBOutlet weak var leftAnimatingImageView: UIImageView!
    @IBOutlet weak var rightAnimatingImageView: UIImageView!
    
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
    
    func initView() {
        //view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(PsspHeaderAutoComputeTextFieldTableViewCell.self)
        tableView.register(PriceProgramAutoComputeTextFieldTableViewCell.self)
        tableView.register(PriceProgramSectionHeaderTableViewCell.self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        headerView.setup(viewModel: headerViewModel)
        bottomNavigationView.setup(viewModel: bottomNavigationViewModel)
    }
    
    func playBoth() {
        rightAnimatingImageView.stopAnimating()
        leftAnimatingImageView.stopAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playLeftConfetti()
            self.playRightConfetti()
        }
    }
    
    func playLeftConfetti() {
        playAudioFile(resource: "pssp-rewards-duration-002")
        animateLeftConfeti()
    }
    
    func playRightConfetti() {
        playAudioFile(resource: "pssp-rewards-duration-003")
        animateRightConfeti()
    }
    
    func animateLeftConfeti() {
        leftAnimatingImageView.animationDuration = 1.0
        leftAnimatingImageView.animationRepeatCount = 1
        leftAnimatingImageView.animationImages = animatedImagesFull(for: "confetti-left")
        leftAnimatingImageView.startAnimating()
    }
    
    func animateRightConfeti() {
        rightAnimatingImageView.animationDuration = 1.0
        rightAnimatingImageView.animationRepeatCount = 1
        rightAnimatingImageView.animationImages = animatedImagesFull(for: "confetti-right")
        rightAnimatingImageView.startAnimating()
    }
    
    func animatedImagesFull(for name: String) -> [UIImage] {
        
        var i = 1
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)-\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    

    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -240 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func initBinding() {
        viewModel.sectionViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
            self?.tableView.reloadData()
        }
        
        viewModel.proceed = {
            SVProgressHUD.dismiss()
            
            if UserManager().user?.isVsmLuzonUser == true {
                self.performSegue(withIdentifier: "PriceProgramToPriceDisplaySegue", sender: nil)
            }else {
                self.performSegue(withIdentifier: "PriceProgramToTradeProgramSegue", sender: nil)
            }
            
            ///self.performSegue(withIdentifier: "LoginToPhotoCaptureSegue", sender: nil)
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
        
        viewModel.playLeftConfetti = {
            self.playLeftConfetti()
        }
        
        viewModel.playRightConfetti = {
            self.playRightConfetti()
        }
        
        viewModel.playBothConfetti = {
            self.playBoth()
        }
        
        viewModel.start()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let priceVc = segue.destination as? PriceDisplayViewController {
            priceVc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
                     
        }
    }
}

extension PriceProgramViewController: UITableViewDelegate, UITableViewDataSource {
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
