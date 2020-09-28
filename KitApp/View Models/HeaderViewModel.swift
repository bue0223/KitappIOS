//
//  HeaderViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class HeaderViewModel {
    var nameLabel: String
    var displayImage: UIImage
    var logoButtonPressed: (() -> Void)?
    
    init(nameLabel: String, displayImage: UIImage) {
        self.nameLabel = nameLabel
        self.displayImage = displayImage
    }
}
