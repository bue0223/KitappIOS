//
//  TradeProgramsViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SVProgressHUD

class TradeProgramsViewController: UIViewController, ViewControllerInterface {
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var viewModel: TradeProgramsViewModel = {
        return TradeProgramsViewModel()
    }()
    
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()
    
    lazy var bottomNavigationViewModel: BottomNavigationViewModel =  {
        return BottomNavigationViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any aString(describing: dditional setup after )loading the view.
        
        initView()
        initBinding()
    }
    
    func initView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (( view.bounds.width / 5.0 ) - 16.0) , height: collectionView.bounds.height * 0.8)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(InfoImageCollectionViewCell.self)
        
        headerView.setup(viewModel: headerViewModel)
        bottomNavigationView.setup(viewModel: bottomNavigationViewModel)
    }
    
    func initBinding() {
        viewModel.updatesContentHeader = { text in
            self.screenTitleLabel.text = text
        }
        
        viewModel.sectionViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
            self?.collectionView.reloadData()
        }
        
//        viewModel.proceed = {
//            SVProgressHUD.dismiss()
//            self.performSegue(withIdentifier: "LoginToPhotoCaptureSegue", sender: nil)
//        }
        
        viewModel.viewInfoImage = { infoimage in
            self.performSegue(withIdentifier: "TradeToInfoSegue", sender: infoimage)
            
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
        
        viewModel.start()
        
        bottomNavigationViewModel.backButtonPressed = {
            self.navigationController?.popViewController(animated: true)
        }
        
        bottomNavigationViewModel.nextButtonPressed = {        
            //if self.viewModel.isFirstScreen == false {
                 self.performSegue(withIdentifier: "TradePrograamToPowerOfBrandSegue", sender: nil)
            //}else {
            //    self.viewModel.isFirstScreen = false
            //}
        }
        
        
        headerViewModel.logoButtonPressed = {
            self.presentPopup(okButtonHandler: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InfoPopupViewController {
            if let model = sender as? InfoImageEntity {
                vc.model = model
            }
        }
        

        if let vc = segue.destination as? PriceDisplayViewController {
            vc.viewModel.userType = UserManager().user?.userType == "retailer" ? .retailer : .wholeSaler
           // vc.totalPmftcProfit = viewModel.totalProfitPmftc
           // vc.totalOtherBrandsProfit = viewModel.totalProfitOthers
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TradeProgramsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionViewModel = viewModel.sectionViewModels.value[section]
        return sectionViewModel.rowViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier(for: rowViewModel), for: indexPath)
        
        if let cell = cell as? CellConfigurable {
            cell.setup(viewModel: rowViewModel)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionViewModels.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sectionViewModel = viewModel.sectionViewModels.value[indexPath.section]
        if let rowViewModel = sectionViewModel.rowViewModels[indexPath.item] as? ViewModelPressible {
            rowViewModel.cellPressed?()
        }
    }
}
