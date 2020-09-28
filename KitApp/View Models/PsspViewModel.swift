//
//  PsspViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class PsspViewModel {
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
    
    var proceed: (() -> Void)?
    
    var isLoading = Observable<Bool>(value: false)
    
    var userType: UserType = .retailer
    
    func start() {
        let infoGraphics: [InfoGraphicsEntity] = (CoreDataManager().fetch(isProducts: false) ?? [])
        
        var psspItems: [PsspProductEntity] = []
        
        psspItems = (infoGraphics.first?.psspItems?.map({ (item) -> PsspProductEntity in
            return (item as! PsspProductEntity)
        }) ?? []).sorted(by: { (a, b) -> Bool in
            return a.order < b.order
        })
        
        var rowViewModels: [RowViewModel] = []
        
        
        let headerViewModel = PsspHeaderTableViewCellViewModel(imageName: userType == .retailer ? "stickprice-pricedisplay" : "packprice-pricedisplay" )
        rowViewModels.append(headerViewModel)
        
        for item in psspItems {
            let firstPrice = userType == .retailer ? item.stick_price.integerPart() : item.pack_price.integerPart()
            
            let decimalPrice = userType == .retailer ? item.stick_price.fractionalPart() : item.pack_price.fractionalPart()
            
            
            let itemViewModel = PsspItemCellViewModel(model: item, firstPrice: firstPrice, firstPriceDecimal: decimalPrice)
                
                rowViewModels.append(itemViewModel)
        }
        
        sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "")]
    }
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is PsspItemCellViewModel:
            return PsspItemTableViewCell.nibName
        case is PsspHeaderTableViewCellViewModel:
            return PsspHeaderTableViewCell.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }

    
}
