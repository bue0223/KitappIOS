//
//  PriceDisplayCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class PriceDisplayCellViewModel: RowViewModel, ViewModelPressible {
    
    var cellPressed: (()->Void)?
    
    var rowHeight: Float = 200.0
    
    var title: String
    var description: String
    var imageData: Data?
    var imageUrlString: String?
    
    var isLeaningUp: Bool = false
    
    var firstPrice: String
    var secondPrice: String
    
    var firstDecimal: String
    var secondDecimal: String
    
    var firstImageName: String
    var secondImageName: String
    
    init(model: ProductEntity, firstPrice: String, firstDecimal: String, secondPrice: String, secondDecimal: String, firstImageName: String, secondImageName: String) {
        
        self.title = model.name ?? ""
        self.description = model.name ?? ""
        self.firstPrice = firstPrice
        self.secondPrice = secondPrice
//        self.title = model.desc ?? ""
//        self.description = model.popupcontent?.desc ?? ""
        self.imageData = model.image
        
        self.imageUrlString = model.image_url
//        self.isLeaningUp = isLeaningUp
//        self.diskImage = diskImage
        
        self.firstDecimal = firstDecimal
        self.secondDecimal = secondDecimal
        
        self.firstImageName = firstImageName
        self.secondImageName = secondImageName
    }
}

class PsspItemCellViewModel: RowViewModel, ViewModelPressible  {
        var cellPressed: (()->Void)?
        
    var rowHeight: Float = 148.0
        
        var imageData: Data?
        var imageUrlString: String?
        var firstPrice: String
        var firstPriceDecimal: String
        
        init(model: PsspProductEntity, firstPrice: String, firstPriceDecimal: String) {
            
            self.firstPrice = firstPrice
            self.firstPriceDecimal = firstPriceDecimal
    //        self.title = model.desc ?? ""
    //        self.description = model.popupcontent?.desc ?? ""
            self.imageUrlString = model.image_url
            self.imageData = model.image
    }
}
