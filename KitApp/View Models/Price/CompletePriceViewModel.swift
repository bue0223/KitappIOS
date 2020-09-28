//
//  CompletePriceViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/19/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit


enum BrandPage {
    case pmftc
    case otherBrands
}

class CompletePriceViewModel {
    let rowViewModels = Observable<[SpreadsheetRowViewModel]>(value: [])
    
    var proceed: ( () -> Void )?
    
    var userType: UserType = .retailer
    
    func numberOfColumns() -> Int{
        return 7
    }
    
    
    var viewButtonPressed: (() -> Void)?
    
    var isOnPmftcPage = true {
        didSet {
            start()
        }
    }
    
    func numberOfRows() -> Int{
        return rowViewModels.value.count
    }
    
    func widthForColumn(column: Int) -> CGFloat {
        return 115.0
    }
    
    func heightForRow(row: Int) -> CGFloat {
        if row == 0 {
            return 120.0
        }
        
        if row == 1 {
            return 50.0
        }
        
        return 40.0
    }
    
    
    var frozenRows: Int {
        return 0
    }
    
    var frozenColumns: Int {
        return 1
    }
    
    enum Sorting {
        case ascending
        case descending
        
        var symbol: String {
            switch self {
            case .ascending:
                return "\u{25B2}"
            case .descending:
                return "\u{25BC}"
            }
        }
    }
    var sortedColumn = (column: 0, sorting: Sorting.ascending)
    
    
    var changesButtonTitle: ((_ title: String) -> Void)?
    
    init() {
        viewButtonPressed = {
            self.isOnPmftcPage = !self.isOnPmftcPage
            
            self.changesButtonTitle?(self.isOnPmftcPage == true ? "VIEW OTHER BRANDS" : "VIEW PMFTC BRANDS")
        }
    }
    
    func start(){
        
        rowViewModels.value = []
        
        let items: [ProductEntity] = (CoreDataManager().fetch() ?? []).filter { (entity) -> Bool in
            return entity.is_product == true
        }
        
        var itemsViewModel: [SpreadsheetItemViewModel] = []
        
        let textViewModel = PriceSheetCellViewModel(text: "PRODUCT")
        textViewModel.type = .topHeader
        
        let image1: UIImage = (userType == .retailer ? UIImage(named: "weeklypacks")! :  UIImage(named: "weeklycarton-wholesale")!)
        
        let textViewModel2 = PriceSheetCellViewModel(text: "", image: image1)
        textViewModel2.type = .topHeader
        
        let image2: UIImage = (userType == .retailer ? UIImage(named: "bentahan")! :  UIImage(named: "bentahanpack-wholesale")!)
        let textViewModel3 = PriceSheetCellViewModel(text: "", image: image2)
        textViewModel3.type = .topHeader
        
        
        let image3: UIImage = (userType == .retailer ? UIImage(named: "totalbenta")! :  UIImage(named: "totalbenta")!)
        let textViewModel4 = PriceSheetCellViewModel(text: "", image: image3)
        textViewModel4.type = .topHeader
        
        let image4: UIImage = (userType == .retailer ? UIImage(named: "puhunanpack")! :  UIImage(named: "puhunanpack-wholesale")!)
        let textViewModel5 = PriceSheetCellViewModel(text: "", image: image4)
        textViewModel5.type = .topHeader
        
        let image5: UIImage = (userType == .retailer ? UIImage(named: "totalpuhunan")! :  UIImage(named: "totalpuhunan")!)
        let textViewModel6 = PriceSheetCellViewModel(text: "", image: image5)
        textViewModel6.type = .topHeader
        
        let textViewModel7 = PriceSheetCellViewModel(text: "")
        textViewModel7.type = .topHeader
        
        itemsViewModel.append(textViewModel)
        itemsViewModel.append(textViewModel2)
        itemsViewModel.append(textViewModel3)
        itemsViewModel.append(textViewModel4)
        itemsViewModel.append(textViewModel5)
        itemsViewModel.append(textViewModel6)
        itemsViewModel.append(textViewModel7)
        
        self.rowViewModels.value.append(SpreadsheetRowViewModel(itemViewModels: itemsViewModel, headerTitle: ""))
        
        var itemsViewModel2: [SpreadsheetItemViewModel] = []
        
        let headerViewModel = PriceSheetCellViewModel(text: "BRAND", backgroundColor: UIColor.darkGray)
        headerViewModel.type = .header
        
        let headerViewModel2 = PriceSheetCellViewModel(text: userType == .retailer ?  "Ave. Weekly Packs" : "Ave. Weekly Cartons", backgroundColor: Constants.ColorTheme.primaryYellow)
        headerViewModel2.type = .header
        
        let headerViewModel3 = PriceSheetCellViewModel(text: "Bentahan", backgroundColor: Constants.ColorTheme.primaryBlue)
        headerViewModel3.type = .header
        
        let headerViewModel4 = PriceSheetCellViewModel(text: "Total Benta", backgroundColor: Constants.ColorTheme.lightBlue)
        headerViewModel4.type = .header
        
        let headerViewModel5 = PriceSheetCellViewModel(text: userType == .retailer ? "Puhunan Kada Pack" : "Puhunan Kada Carton", backgroundColor: Constants.ColorTheme.primaryOrange)
        headerViewModel5.type = .header
        
        let headerViewModel6 = PriceSheetCellViewModel(text: "Total Puhunan", backgroundColor: Constants.ColorTheme.lightOrange)
        headerViewModel6.type = .header
        
        let headerViewModel7 = PriceSheetCellViewModel(text: "KITA", image: UIImage(named: "kitalogo"))
        headerViewModel7.type = .topHeader
        itemsViewModel2.append(headerViewModel)
        itemsViewModel2.append(headerViewModel2)
        itemsViewModel2.append(headerViewModel3)
        itemsViewModel2.append(headerViewModel4)
        itemsViewModel2.append(headerViewModel5)
        itemsViewModel2.append(headerViewModel6)
        itemsViewModel2.append(headerViewModel7)
        
        self.rowViewModels.value.append(SpreadsheetRowViewModel(itemViewModels: itemsViewModel2, headerTitle: ""))
        
        
        var counter = 0
        for item in items {
            
            
            var itemsViewModel: [SpreadsheetItemViewModel] = []
            
            let textViewModel = PriceSheetCellViewModel(text: item.name ?? "", imageData: item.image, model: item)
            textViewModel.type = counter % 2 == 0 ? .body : .body2
            
            let textViewModel2 = PriceSheetCellViewModel(text: userType == .retailer ?  "\(item.ave_weekly_packs)" : "\(item.ave_weekly_cartons)", model: item)
            textViewModel2.type = counter % 2 == 0 ? .body : .body2
            
            let textViewModel3 = PriceSheetCellViewModel(text: userType == .retailer ?  item.stick_price.formattedAmount : item.pack_price_wholesale.formattedAmount, model: item)
            textViewModel3.type = counter % 2 == 0 ? .body : .body2
            
            let textViewModel4 = PriceSheetCellViewModel(text: userType == .retailer ?  item.totalBentaRetailer.formattedAmount : item.totalBentaWholesaler.formattedAmount, model: item)
            textViewModel4.type = counter % 2 == 0 ? .body : .body2
            
            let textViewModel5 = PriceSheetCellViewModel(text: userType == .retailer ?  item.pack_price_retail.formattedAmount : item.ream_price_wholesale.formattedAmount, model: item)
            textViewModel5.type = counter % 2 == 0 ? .body : .body2
            
            let textViewModel6 = PriceSheetCellViewModel(text: userType == .retailer ?  item.totalPuhunanRetailer.formattedAmount : item.totalPuhunanWholesaler.formattedAmount, model: item)
            textViewModel6.type = counter % 2 == 0 ? .body : .body2
            
            let textViewModel7 = PriceSheetCellViewModel(text: userType == .retailer ?  item.totalKitaRetailer.formattedAmount : item.totalKitaWholesaler.formattedAmount, model: item)
            textViewModel7.type = counter % 2 == 0 ? .body : .body2
            
            
            itemsViewModel.append(textViewModel)
            itemsViewModel.append(textViewModel2)
            itemsViewModel.append(textViewModel3)
            itemsViewModel.append(textViewModel4)
            itemsViewModel.append(textViewModel5)
            itemsViewModel.append(textViewModel6)
            itemsViewModel.append(textViewModel7)
            
            counter += 1
            self.rowViewModels.value.append(SpreadsheetRowViewModel(itemViewModels: itemsViewModel, headerTitle: ""))
        }
        
        var computeTotalPuhunan = 0.0
        var computeTotalBenta = 0.0
        var computeTotalKita = 0.0
        
        for rowViewModel in self.rowViewModels.value {
            
            if let priceItemVm = rowViewModel.itemViewModels[3] as? PriceSheetCellViewModel {
                if priceItemVm.model != nil {
                    computeTotalPuhunan =  computeTotalPuhunan + (priceItemVm.model?.totalPuhunanRetailer ?? 0.0)
                    
                    computeTotalBenta =  computeTotalBenta + (priceItemVm.model?.totalBentaRetailer ?? 0.0)
                    
                    computeTotalKita =  computeTotalKita + (priceItemVm.model?.totalKitaRetailer ?? 0.0)
                }
            }
        }
        
        var itemsViewModel3: [SpreadsheetItemViewModel] = []
        
        let footerViewModel = PriceSheetCellViewModel(text: "TOTAL PMFTC", backgroundColor: UIColor.red)
        footerViewModel.type = .header
        
        let footerViewModel2 = PriceSheetCellViewModel(text: "-", backgroundColor: UIColor.red)
        footerViewModel2.type = .header
        
        let footerViewModel3 = PriceSheetCellViewModel(text: "-", backgroundColor: UIColor.red)
        footerViewModel3.type = .header
        
        let footerViewModel4 = PriceSheetCellViewModel(text: computeTotalBenta.formattedAmount, backgroundColor: UIColor.red)
        footerViewModel4.type = .header
        
        let footerViewModel5 = PriceSheetCellViewModel(text: "-", backgroundColor: UIColor.red)
        footerViewModel5.type = .header
        
        let footerViewModel6 = PriceSheetCellViewModel(text: computeTotalPuhunan.formattedAmount, backgroundColor: UIColor.red)
        footerViewModel6.type = .header
        
        let footerViewModel7 = PriceSheetCellViewModel(text: computeTotalKita.formattedAmount, backgroundColor: UIColor.red)
        footerViewModel7.type = .header
        itemsViewModel3.append(footerViewModel)
        itemsViewModel3.append(footerViewModel2)
        itemsViewModel3.append(footerViewModel3)
        itemsViewModel3.append(footerViewModel4)
        itemsViewModel3.append(footerViewModel5)
        itemsViewModel3.append(footerViewModel6)
        itemsViewModel3.append(footerViewModel7)
        
        self.rowViewModels.value.append(SpreadsheetRowViewModel(itemViewModels: itemsViewModel3, headerTitle: ""))
    }
    
    func cellIdentifier(for viewModel: SpreadsheetItemViewModel) -> String {
        switch viewModel {
        case is PriceSheetCellViewModel:
            return PriceSheetCellView.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}
