//
//  VerticalAlignLabelTemplateTableViewCellViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation


class VerticalAlignLabelTemplateTableViewCellViewModel: RowViewModel {
    var rowHeight: Float = 100.0

    var title: String
    var subTitle: String
    
    init(title: String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
}
