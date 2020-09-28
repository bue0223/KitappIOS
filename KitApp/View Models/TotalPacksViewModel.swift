//
//  TotalPacksViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class TotalPacksViewModel: TableViewConfigurable {
    var sectionViewModels = Observable<[SectionViewModel]>(value: [])
    
    func start() {
        let verticalTemplateViewModel = VerticalAlignLabelTemplateTableViewCellViewModel(title: "PMFTC", subTitle: "1000")
        
        sectionViewModels.value = [SectionViewModel(rowViewModels: [verticalTemplateViewModel], headerTitle: "Total Rewards")]
    }
}
