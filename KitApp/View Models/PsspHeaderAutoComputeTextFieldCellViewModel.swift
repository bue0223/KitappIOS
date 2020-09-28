//
//  PsspHeaderAutoComputeTextFieldCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit


class PsspHeaderAutoComputeTextFieldCellViewModel: RowViewModel {
    var rowHeight: Float = 200.0
    
    var text: Observable<String>
    var subText: Observable<String>
    var keyboardType: UIKeyboardType?
    var isSecure: Bool?
    var imageName: String?
    
    var displayText: String?
  
    var isDisplayLabelHidden: Bool = true
    var isSubFieldHidden: Bool = false
    var isSubFieldUserInteractionEnabled: Bool = false
    
    init(text: Observable<String>, isSubFieldHidden: Bool = false, subText: Observable<String> = Observable<String>(value: ""), displayText: String?) {
        self.text = text
        self.isSubFieldHidden = false
        self.displayText = displayText
        self.subText = subText
//
//        switch type {
//        case .inputPacks:
//            self.placeholder = model.name
//        case .inputRewards:
//            self.placeholder = model.name
//            self.isSubFieldHidden = true
//        default:
//            print("")
//        }
        
        //self.imageData = model.image
        
//        self.isDisplayLabelHidden = model.image != nil
//        self.isSubFieldUserInteractionEnabled = !model.is_product
      
        text.addObserver(fireNow: false, { (text) in
//            switch type {
//            case .inputPacks:
//                if model.is_product == true {
//                    let packs = Double(text) ?? 0.0
//                    let profit = model.computeProfitRetailer(packs: packs)
//                    subText.value = "\(profit)"
//                }
//            case .inputRewards:
//                print("")
//            default:
//                print("")
//            }
            
        })
    }
}
