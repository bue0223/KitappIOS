//
//  ComparisonViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class ComparisonViewController: UIViewController, ViewControllerInterface {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pmftcLabel: UILabel!
    @IBOutlet weak var otherbrandsLabel: UILabel!
    
    @IBOutlet weak var comparisonImageView: UIImageView!
    
    @IBOutlet weak var pmftcBackgroundView: UIImageView!
    
    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()
    
    
    lazy var viewModel: ComparisonViewModel = {
        return ComparisonViewModel()
    }()
    
    lazy var bottomNavigationViewModel: BottomNavigationViewModel =  {
        return BottomNavigationViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.setup(viewModel: headerViewModel)
        bottomNavigationView.setup(viewModel: bottomNavigationViewModel)

        // Do any additional setup after loading the view.
        initView()
        initBinding()
    }
    
    
    func initView() {
        pmftcBackgroundView.isHidden = !viewModel.pmftcWinsComparison
        
        pmftcLabel.textColor = viewModel.pmtcTextColor
        otherbrandsLabel.textColor = viewModel.otherBrandsTextColor
        comparisonImageView.image = UIImage(named: viewModel.comparisonImagename)
        
        pmftcLabel.text = viewModel.pmftcTotalProfit.formattedAmount
        otherbrandsLabel.text = viewModel.otherBrandsTotalProfit.formattedAmount
        
        topLabel.text = viewModel.topLabelText
    }

    func initBinding() {
//          viewModel.proceed = {
//              self.performSegue(withIdentifier: "PriceToComparisonSegue", sender: nil)
//          }
//
//          viewModel.rowViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
//              self?.spreadsheetView.reloadData()
//          }
//
//          viewModel.start()
//
          bottomNavigationViewModel.backButtonPressed = {
              self.navigationController?.popViewController(animated: true)
          }
          
          bottomNavigationViewModel.nextButtonPressed = {
              //self.viewModel.validate()
              //self.viewModel.proceed?()
              
          }
          
          
          headerViewModel.logoButtonPressed = {
                          self.presentPopup(okButtonHandler: {
                  self.navigationController?.popToRootViewController(animated: true)
              })
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
