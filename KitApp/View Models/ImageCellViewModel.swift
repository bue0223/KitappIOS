//
//  ImageCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

enum ImageType {
    case logo
    case profile
}

class ImageCellViewModel: RowViewModel {
    var imageType: ImageType
    var cornerRadius: Float = 0.0
    var backGroundColor: UIColor {
        switch imageType {
        case .profile:
            return Constants.ColorTheme.systemGray5
        case .logo:
            return UIColor.clear
        }
    }

    var image: Observable<UIImage>?
    
    var rowHeight: Float = 0
    var name: String
    
    init(name: String, type: ImageType = .logo, image: Observable<UIImage> = Observable<UIImage>(value: UIImage())) {
        self.name = name
        self.imageType = type
        self.image = image
        
        switch imageType {
        case .profile:
            rowHeight = 240.0
        default:
            rowHeight = 130.0
        }
    }
}
