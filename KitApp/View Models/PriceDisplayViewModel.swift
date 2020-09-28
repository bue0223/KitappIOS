//
//  PriceDisplayViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class PriceDisplayViewModel {
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
    
    var proceed: (() -> Void)?
    
    var inputs: [InputValueType: String] = [:]
    
    var isLoading = Observable<Bool>(value: false)
    
    var contentManager: ContentManagerProtocol
    
    var viewInfoImage: ((_ infoImage: InfoImageEntity) -> Void)?
    
    var userType: UserType = .retailer
    
    init(contentManager: ContentManagerProtocol = ContentManager()) {
        self.contentManager = contentManager
    }
    
    var contentTitle: String {
        return messages.filter { (message) -> Bool in
            return message.page == "2"
            }.first?.content ?? "Handa kana ba maging ALL-IN sa negosyo?"
    }
    
    var messages: [MessageEntity] = CoreDataManager().fetch(isProducts: false) ?? []
    
    var updatesContentHeader: ((_ text: String) -> ())?
    
    func start() {
        updatesContentHeader?(contentTitle)
        
        let items: [ProductEntity] = (CoreDataManager().fetch(isProducts: true) ?? [])
        var rowViewModels: [RowViewModel] = []
        
        for item in items {
            let firstPrice = userType == .retailer ? item.stick_price.integerPart() : item.stick_price_wholesale.integerPart()
            
            let firstPriceDecimal = userType == .retailer ? item.stick_price.fractionalPart() : item.stick_price_wholesale.fractionalPart()
            
            let secondPrice = userType == .retailer ? item.pack_price_retail.integerPart() : item.pack_price_wholesale.integerPart()
            
            let secondPriceDecimal = userType == .retailer ? item.pack_price_retail.fractionalPart() : item.pack_price_wholesale.fractionalPart()

            let firstimage = userType == .retailer ? "stickprice-pricedisplay" : "packprice-pricedisplay"

            let secondimage = userType == .retailer ? "packprice-pricedisplay" : "cartonprice-pricedisplay"
            
            
            let itemViewModel = PriceDisplayCellViewModel(model: item, firstPrice: firstPrice, firstDecimal: firstPriceDecimal ,secondPrice: secondPrice, secondDecimal: secondPriceDecimal, firstImageName: firstimage, secondImageName: secondimage)
                
                itemViewModel.cellPressed = {
                  //  self.viewInfoImage?(item)
                }
                
                rowViewModels.append(itemViewModel)
        }
        
        sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "")]
        
    }
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is PriceDisplayCellViewModel:
            return ProductDisplayCollectionViewCell.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}
