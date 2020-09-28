//
//  PriceViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import SpreadsheetView

class PriceViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate, ViewControllerInterface {
    
    lazy var viewModel: PriceViewModel = {
        return PriceViewModel()
    }()
    
    
    var totalPmftcProfit: Double = 0.0
    var totalOtherBrandsProfit: Double = 0.0
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var bottomNavigationView: BottomNavigationView!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
        
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()
    
    lazy var bottomNavigationViewModel: BottomNavigationViewModel =  {
        return BottomNavigationViewModel()
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.register(SampleSheetCellView.self, forCellWithReuseIdentifier: String(describing: SampleSheetCellView.self))
        
//        spreadsheetView.roundCorners([.topLeft, .topRight], radius: 20.0)
        spreadsheetView.bounces = false
        spreadsheetView.gridStyle = .none

        headerView.setup(viewModel: headerViewModel)
        bottomNavigationView.setup(viewModel: bottomNavigationViewModel)
        
        initBinding()
    }
    
    func initBinding() {
        viewModel.proceed = {
            self.performSegue(withIdentifier: "PriceToComparisonSegue", sender: nil)
        }
        
        viewModel.rowViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
            self?.spreadsheetView.reloadData()
        }
        
        viewModel.start()
        
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return viewModel.numberOfColumns()
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return viewModel.numberOfRows()
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return viewModel.widthForColumn(column: column)
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return viewModel.heightForRow(row: row)
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return viewModel.frozenRows 
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {

        let itemViewModel = viewModel.rowViewModels.value[indexPath.row].itemViewModels[indexPath.column]

            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: viewModel.cellIdentifier(for: itemViewModel), for: indexPath)

            if let cell = cell as? SpreadsheetCellConfigurable {
                cell.setup(viewModel: itemViewModel)
            }

            return cell
    }
}
