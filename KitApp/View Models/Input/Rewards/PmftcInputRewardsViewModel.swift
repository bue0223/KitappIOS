//
//  PmftcInputRewardsViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/10/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class PmftcInputRewardsViewModel: TableViewConfigurable {
    var sectionViewModels = Observable<[SectionViewModel]>(value: [])
    var isUpdatingValue = Observable<Bool>(value: false)
    var sumValue = 0.0
    
    var userType: UserType = .retailer
    
    init(userType: UserType) {
        self.userType = userType
    }
    
    func start() {
 
        var items: [ProductEntity] = []
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let item1 = ProductEntity(context: managedContext)
        item1.id = UUID().uuidString
        item1.name = userType == .retailer ? "APP WARDS" : "STAR"
        item1.image = UIImage(named: userType == .retailer ? "appwards" : "star")?.jpegData(compressionQuality: 0.5)
        item1.is_product = false
        
        let item2 = ProductEntity(context: managedContext)
        item2.id = UUID().uuidString
        item2.name = "PRICE PROGRAM"
        item2.is_product = false
        
  
        let item3 = ProductEntity(context: managedContext)
        item3.id = UUID().uuidString
        item3.name = "OTHER PROMOS 1"
        item3.is_product = false
        
        
        let item4 = ProductEntity(context: managedContext)
        item4.id = UUID().uuidString
        item4.name = "OTHER PROMOS 2"
        item4.is_product = false
        
        items.append(contentsOf: [item1, item2, item3, item4])
        
        var rowViewModels: [RowViewModel] = []
        
        for item in items {
            let textViewModel = AutoComputeTextFieldCellViewModel(text: Observable<String>(value: ""), type: .inputRewards, model: item)
            
            textViewModel.text.addObserver(fireNow: false) { (text) in
                self.compute()
            }
            
            rowViewModels.append(textViewModel)
        }

        
        sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "PMFTC")]
    }
    
    func compute() {
        sumValue = 0.0
        for item in (sectionViewModels.value.first?.rowViewModels ?? []) {
            if let autoComputeViewModel = item as? AutoComputeTextFieldCellViewModel {
                sumValue = sumValue + (Double(autoComputeViewModel.text.value) ?? 0.0)
            }
        }
        
        isUpdatingValue.value = true
    }
}

class PmftcSecondInputRewardsViewModel: TableViewConfigurable {
    var sectionViewModels = Observable<[SectionViewModel]>(value: [])
    var isUpdatingValue = Observable<Bool>(value: false)
    var sumValue = 0.0
    
    var userType: UserType = .retailer
    
    init(userType: UserType) {
        self.userType = userType
    }
    
    func start(items: [ProductEntity]) {
 
        let items: [ProductEntity] = items

        var rowViewModels: [RowViewModel] = []
        
        for item in items {
            let textViewModel = AutoComputeTextFieldCellViewModel(text: Observable<String>(value: ""), type: .inputRewards, model: item)
            
            textViewModel.text.addObserver(fireNow: false) { (text) in
                self.compute()
            }
            
            rowViewModels.append(textViewModel)
        }

        
        sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "PMFTC")]
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
