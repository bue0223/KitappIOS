//
//  AutoComputeTextFieldCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class AutoComputeTextFieldCellViewModel: RowViewModel {
    var rowHeight: Float = 60.0
    
    var text: Observable<String>
    var subText: Observable<String>
    var type: TextFieldTableViewCellType
    
    var placeholder: String?
    var keyboardType: UIKeyboardType?
    var isSecure: Bool?
    var imageData: Data?
    
    var model: ProductEntity
    
    var isDisplayLabelHidden: Bool = true
    var isSubFieldHidden: Bool = false
    var isSubFieldUserInteractionEnabled: Bool = false
    
    init(text: Observable<String>, type: TextFieldTableViewCellType, model: ProductEntity, isSubFieldHidden: Bool = false, subText: Observable<String> = Observable<String>(value: "")) {
        self.text = text
        self.type = type
        self.isSubFieldHidden = false
        
        self.subText = subText
    
        switch type {
        case .inputPacks:
            self.placeholder = model.name
        case .inputRewards:
            self.placeholder = model.name
            self.isSubFieldHidden = true
        default:
            print("")
        }
        
        self.imageData = model.image
        
        self.isDisplayLabelHidden = model.image != nil
        self.isSubFieldUserInteractionEnabled = !model.is_product
        self.model = model
        
        
        text.addObserver(fireNow: false, { (text) in
            switch type {
            case .inputPacks:
                if model.is_product == true {
                    let packs = Double(text) ?? 0.0
                    let profit = model.computeProfitRetailer(packs: packs)
                    subText.value = "\(profit)"
                }
            case .inputRewards:
                print("")
            default:
                print("")
            }
            
        })
    }
}
