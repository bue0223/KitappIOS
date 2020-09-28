//
//  ButtonTableViewCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class ButtonTableViewCellViewModel: RowViewModel {
    var rowHeight: Float = 70.0
        
    var buttonPressed: (() -> Void)?

    var text: Observable<String>
    
    var enabled: Observable<Bool>
    
    var colorTheme = Constants.ColorTheme.appTheme
    
    var buttonType: ButtonType = .Continue

    init(text: Observable<String>, enabled: Observable<Bool> = Observable<Bool>(value: true), buttonType: ButtonType = .Continue) {
        self.text = text
        self.enabled = enabled
        self.buttonType = buttonType
        
        switch buttonType {
        case .Photo:
            rowHeight = 80.0
        case .PhotoContinue:
            rowHeight = 80.0
        default:
            rowHeight = 70.0
        }
    }
}
