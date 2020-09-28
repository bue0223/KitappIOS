//
//  InfoGraphicCollectionViewCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/27/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class InfoImageCollectionViewCellViewModel: RowViewModel, ViewModelPressible {
    
    var cellPressed: (()->Void)?
    
    var rowHeight: Float = 200.0
    
    var title: String
    var description: String
    var imageData: Data?
    
    
    var imageUrlString: String?
    var diskImage: String
    var isLeaningUp: Bool = false
    
    init(model: InfoImageEntity, isLeaningUp: Bool, diskImage: String) {
        self.title = model.caption ?? ""
        self.description = model.popupcontent?.desc ?? ""
        self.imageData = model.image
        self.imageUrlString = model.image_url
        self.isLeaningUp = isLeaningUp
        self.diskImage = diskImage
    }
}
