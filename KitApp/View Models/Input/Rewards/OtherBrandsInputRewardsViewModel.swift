//
//  OtherBrandsInputRewardsViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/10/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class OtherBrandsInputRewardsViewModel: TableViewConfigurable {
    var sectionViewModels = Observable<[SectionViewModel]>(value: [])
    var isUpdatingValue = Observable<Bool>(value: false)
    var sumValue = 0.0
    
    var userType: UserType = .retailer
    
    init(userType: UserType) {
         self.userType = userType
    }
    
    func start(items: [ProductEntity]) {
        var items: [ProductEntity] = items
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let item = ProductEntity(context: managedContext)
        item.id = UUID().uuidString
        item.name = "OTHER PROMOS 1"
        item.is_product = false
        
        items.append(item)

        var rowViewModels: [RowViewModel] = []
        
        for item in items {
            let textViewModel = AutoComputeTextFieldCellViewModel(text: Observable<String>(value: ""), type: .inputRewards, model: item)
            
            textViewModel.text.addObserver(fireNow: false) { (text) in
                self.compute()
            }
            
            rowViewModels.append(textViewModel)
        }

        
        sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "Other Brands")]
    }
    
    func compute() {
        sumValue = 0.0
        for item in (sectionViewModels.value.first?.rowViewModels ?? []) {
            if let autoComputeViewModel = item as? AutoComputeTextFieldCellViewModel {
                if autoComputeViewModel.model.with_reward == false {
                    sumValue = sumValue + (Double(autoComputeViewModel.text.value) ?? 0.0)
                }else {
                    
                    let userTypeString = userType == .wholeSaler ? "Wholesale" : "Retail"
        
                    
                    if let reward = autoComputeViewModel.model.rewards?.first(where: { (rewardEntity) -> Bool in
                        if let reward = rewardEntity as? RewardEntity {
                            return reward.type == userTypeString
                        }
                        
                        return false
                    }) as? RewardEntity {
                        sumValue = sumValue + ((Double(autoComputeViewModel.text.value) ?? 0.0) * reward.reward)
                    }else {
                        sumValue = sumValue + (Double(autoComputeViewModel.text.value) ?? 0.0)
                    }
                }
            }
        }
        
        isUpdatingValue.value = true
    }
}
