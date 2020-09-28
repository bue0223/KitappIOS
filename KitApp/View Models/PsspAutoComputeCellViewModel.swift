//
//  PsspAutoComputeCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit


class PsspAutoComputeCellViewModel: RowViewModel {
    var rowHeight: Float = 50.0
    
    var leftTextMaxCharLimitCount: Int = 6
    
    var text: Observable<String>
    var subText: Observable<String>
    var subValue: Decimal?
    var itemQuantity: Double? 
    
    var imageName: String?
    
    
    var percentageLabel: String?
    var label: String?
    var model: PriceProgramItemEntity?
    
    var imageData: Data?
    var imageUrlString: String?
   // var isCheckButtonEnabled: Bool = false
    
    var isCircleImageHidden: Bool = false
    
    var isCheckImageHidden: Bool = false
    
    var isPercentageLabelHiddden: Bool = false
    var isDisplayImageViewHidden: Bool = false
    
    var isUnderlineViewHidden: Bool = true
    
    var isTextFieldInteractionEnabled = false
    
    var isInputDisplayed: Observable<Bool> = Observable<Bool>(value: true)
    
    var isCheckButtonEnabled: Observable<Bool> = Observable<Bool>(value: false)
    
    
    init(model: PriceProgramItemEntity? = nil, text: Observable<String> = Observable<String>(value: ""), subText: Observable<String> = Observable<String>(value: ""), isInputDisplayed: Observable<Bool> = Observable<Bool>(value: true)) {
        self.text = text
        self.label = model?.label
        self.subText = subText
        self.model = model
        self.imageUrlString = model?.image_url
        self.imageData = model?.image
        
        let isReward = model?.is_reward ?? false
        
        isPercentageLabelHiddden = !isReward
        isDisplayImageViewHidden = isReward
        
        isCircleImageHidden = model?.row == 1 || model?.row == 2 || model?.row == 5
        isCheckButtonEnabled.value = false
        
        isCheckImageHidden = true
        
        isTextFieldInteractionEnabled = isReward == false
        
        //let percentage = Int(model?.percentage_value ?? 0.0)
        
        percentageLabel = model?.percentage_label ?? ""
      
        text.addObserver(fireNow: false, { (text) in
            let cartonPrice = model?.carton_price ?? 0.0
            let textStripped = text.replacingOccurrences(of: ",", with: "")
            let quantity = Double(textStripped) ?? 0.0
            let totalPrice = quantity * cartonPrice
            
            if isReward == false  {
                subText.value = totalPrice.formattedAmount
            }
            
        })
        
        
        self.isInputDisplayed = isInputDisplayed
        
        isInputDisplayed.addObserver(fireNow: false) { (isDisplayed) in
            self.isCheckImageHidden = !isDisplayed
        }
    }
}
