//
//  PriceViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class PriceViewModel {
    let rowViewModels = Observable<[SpreadsheetRowViewModel]>(value: [])
    
    var proceed: ( () -> Void )?
    
    var userType: UserType = .retailer
    
    func numberOfColumns() -> Int{
        return 3
    }
    
    func numberOfRows() -> Int{
        return rowViewModels.value.count
    }
    
    func widthForColumn(column: Int) -> CGFloat {         
        return 260.0
    }
    
    func heightForRow(row: Int) -> CGFloat {
        return 80.0
    }
    
    
    var frozenRows: Int {
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
    
    func start(){
        
        let items: [ProductEntity] = (CoreDataManager().fetch() ?? []).filter { (entity) -> Bool in
            return entity.is_product == true
        }
        
        var itemsViewModel: [SpreadsheetItemViewModel] = []
        
        let textViewModel = SpreadSheetCellViewModel(text: "PRODUCT")
        textViewModel.type = .priceSheetHeader
        
    let image1: UIImage = (userType == .retailer ? UIImage(named: "stickprice")! :  UIImage(named: "packprice")!)
        
        let textViewModel2 = SpreadSheetCellViewModel(text: userType == .retailer ?  "STICK PRICE" : "PACK PRICE", image: image1)
        textViewModel2.type = .priceSheetHeaderWithImage
        
        let image2: UIImage = (userType == .retailer ? UIImage(named: "packprice")! :  UIImage(named: "cartonprice")!)
        let textViewModel3 = SpreadSheetCellViewModel(text: userType == .retailer ? "PACK PRICE" : "CARTON PRICE", image: image2)
        textViewModel3.type = .priceSheetHeaderWithImage
         itemsViewModel.append(textViewModel)
         itemsViewModel.append(textViewModel2)
         itemsViewModel.append(textViewModel3)
        
        self.rowViewModels.value.append(SpreadsheetRowViewModel(itemViewModels: itemsViewModel, headerTitle: ""))
        
        for item in items {
            
            
            var itemsViewModel: [SpreadsheetItemViewModel] = []
            
            
            let textViewModel = SpreadSheetCellViewModel(text: item.name ?? "", imageData: item.image)
            textViewModel.type = .priceSheetItemWithImage
            
            let textViewModel2 = SpreadSheetCellViewModel(text: userType == .retailer ?  item.stick_price.formattedAmount : item.pack_price_wholesale.formattedAmount)
            textViewModel2.type = .priceSheetItem
            
            let textViewModel3 = SpreadSheetCellViewModel(text: userType == .retailer ?  item.pack_price_retail.formattedAmount : item.ream_price_wholesale.formattedAmount)
            textViewModel3.type = .priceSheetItem
            itemsViewModel.append(textViewModel)
            itemsViewModel.append(textViewModel2)
            itemsViewModel.append(textViewModel3)
            self.rowViewModels.value.append(SpreadsheetRowViewModel(itemViewModels: itemsViewModel, headerTitle: ""))
        }
    }
    
    func cellIdentifier(for viewModel: SpreadsheetItemViewModel) -> String {
        switch viewModel {
        case is SpreadSheetCellViewModel:
            return SampleSheetCellView.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}
