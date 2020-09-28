//
//  TextFieldCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class TextFieldCellViewModel: RowViewModel {
    var rowHeight: Float = 90.0
    
    
    var maxCharLimitCount: Int = 100
    
    var text: Observable<String>
    var type: TextFieldTableViewCellType = .email {
        didSet {
            switch type {
            case .email:
                self.placeholder = "EMAIL"
                self.keyboardType = .emailAddress
            case .password:
                self.placeholder = "PASSWORD"
                self.isSecure = true
            case .userType:
                self.placeholder = "Select user type"
            case .storeName:
                self.placeholder = "Store name"
                self.maxCharLimitCount = 20
            case .ownerName:
                self.placeholder = "Owner's name"
                self.maxCharLimitCount = 20
            default:
                break
            }
        }
    }
    
    var enabled: Observable<Bool>
    
    var placeholder: String?
    var keyboardType: UIKeyboardType?
    var isSecure: Bool?
    
    
    var isButtonType: Bool = false
    
    var buttonPressed: (() -> Void)?
    
    init(text: Observable<String>, enabled: Observable<Bool> = Observable<Bool>(value: true), isButtonType: Bool = false) {
        self.text = text
        self.enabled = enabled
        self.isButtonType = isButtonType
    }
}
