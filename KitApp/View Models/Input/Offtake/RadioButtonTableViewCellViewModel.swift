//
//  RadioButtonTableViewCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class RadioButtonTableViewCellViewModel: RowViewModel {
    var rowHeight: Float = 70.0
    
    var enabled: Observable<Bool>
    
    var firstButtonPressed: (()->())?
    var secondButtonPressed: (()->())?
    
    
    var isAutoPickFirstItem: Observable<Bool> = Observable<Bool>(value: false)

    var text: Observable<String>
    
    init(text: Observable<String>, enabled: Observable<Bool> = Observable<Bool>(value: true), isAutoPickFirstItem: Observable<Bool> = Observable<Bool>(value: false)) {
        self.text = text
        self.enabled = enabled
        self.isAutoPickFirstItem = isAutoPickFirstItem
    }
}
