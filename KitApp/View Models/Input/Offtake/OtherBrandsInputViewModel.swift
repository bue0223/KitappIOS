//
//  OtherBrandsInputViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class OtherBrandsInputViewModel: TableViewConfigurable {
    var sectionViewModels = Observable<[SectionViewModel]>(value: [])
    var isUpdatingValue = Observable<Bool>(value: false)
    var sumValue = 0.0
    var offTake = 0.0
    
    func start(items: [ProductEntity]) {
        var items: [ProductEntity] = items
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let item1 = ProductEntity(context: managedContext)
        item1.id = UUID().uuidString
        item1.name = "OTHER BRANDS"
        item1.is_product = false
        
        items.append(item1)
        
        var rowViewModels: [RowViewModel] = []

        for item in items {
            let textViewModel = AutoComputeTextFieldCellViewModel(text: Observable<String>(value: ""), type: .inputPacks, model: item)
             
            textViewModel.text.addObserver(fireNow: false) { (text) in
                self.compute()
            }
            
            if textViewModel.model.is_product == false {
                textViewModel.subText.addObserver(fireNow: false) { (text) in
                    self.compute()
                }
            }
            
             rowViewModels.append(textViewModel)
         }
        
        sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "OTHER BRANDS")]
    }
    
    func compute() {
        sumValue = 0.0
        offTake = 0.0
        for item in (sectionViewModels.value.first?.rowViewModels ?? []) {
            if let autoComputeViewModel = item as? AutoComputeTextFieldCellViewModel {
                offTake = offTake + (Double(autoComputeViewModel.text.value) ?? 0.0)
                sumValue = sumValue + (Double(autoComputeViewModel.subText.value) ?? 0.0)
            }
        }
        
        isUpdatingValue.value = true
    }
}
