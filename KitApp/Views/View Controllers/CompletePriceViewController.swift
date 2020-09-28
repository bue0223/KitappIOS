//
//  CompletePriceViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/19/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import SpreadsheetView

class CompletePriceViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate, ViewControllerInterface {
    
    lazy var viewModel: CompletePriceViewModel = {
        return CompletePriceViewModel()
    }()
    
    @IBOutlet weak var headerView: HeaderView!
    
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    @IBOutlet weak var viewOtherBrandsButton: UIButton!
    
    lazy var headerViewModel: HeaderViewModel =  {
        return HeaderViewModel(nameLabel: "\(UserManager().user?.storeName ?? "")", displayImage: UIImage(data: UserManager().user?.displayImage ?? Data()) ?? UIImage(named: "profileplaceholder")!)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.register(PriceSheetCellView.self, forCellWithReuseIdentifier: String(describing: PriceSheetCellView.self))
        
        //spreadsheetView.roundCorners([.topLeft, .topRight], radius: 20.0)
        spreadsheetView.bounces = false
        spreadsheetView.gridStyle = .none
        
        spreadsheetView.gridStyle = GridStyle.solid(width: 1, color: Constants.ColorTheme.systemGray4)
        //spreadsheetView.intercellSpacing = CGSize(width: 1, height: 1)
        
        headerView.setup(viewModel: headerViewModel)

        initBinding()
    }
    
    func initBinding() {
        
        viewModel.changesButtonTitle = { title in
            self.viewOtherBrandsButton.setTitle(title, for: .normal)
        }
        
        viewModel.rowViewModels.addObserver(fireNow: false) { [weak self] (sectionViewModels) in
            self?.spreadsheetView.reloadData()
        }
        
        viewModel.start()
        
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
    
    @IBAction func leftButtonNavigationPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightButtonNavigationPressed(_ sender: UIButton) {
        //self.viewModel.validate()
    }

    
    @IBAction func viewOtherBrandsPressed(_ sender: Any) {
        viewModel.viewButtonPressed?()
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
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return viewModel.frozenColumns
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
