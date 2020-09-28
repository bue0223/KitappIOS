//
//  TitleWithSubTitleTemplateTableViewCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit


enum TemplateType {
    case withSubtitle
    case withoutSubtitle
}

class TitleWithSubTitleTemplateTableViewCellViewModel: RowViewModel {
    
    var type: TemplateType = .withSubtitle
    var titleColor: UIColor = Constants.ColorTheme.appTheme
    
    var rowHeight: Float = 0.0
    
    var title: String
    var subTitle: String
    
    var isSubTitleHidden: Bool = false
    
    var size: CGFloat = 40.0
    
    init(title: String, subTitle: String, titleColor: UIColor = Constants.ColorTheme.appTheme, type: TemplateType = .withSubtitle, size: CGFloat = 40.0) {
        self.title = title
        self.subTitle = subTitle
        self.titleColor = titleColor
        self.type = type
        self.size = size
        
        switch type {
        case .withSubtitle:
            rowHeight = Float(size * 3)
            isSubTitleHidden = false
        case .withoutSubtitle:
            rowHeight = Float(size * 2)
            isSubTitleHidden = true
        }
    }
}
