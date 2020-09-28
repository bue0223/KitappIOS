//
//  InputViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit


enum InputPageType {
    case offtake
    case rewards
}

class InputViewModel {
    var tableViewModels = Observable<[TableViewConfigurable]>(value: [])
    
    var isUpdatingValue = Observable<Bool>(value: false)
    
    var inputType: InputPageType = .offtake
    var isLoading = Observable<Bool>(value: false)
    
    var updatesTopHeaderText: ((_ text: String) -> Void)?
    
    var userType: UserType = .retailer
    
    var proceed: (() -> Void)?
    
    var items: [ProductEntity] = (CoreDataManager().fetch(isProducts: true) ?? [])
    
    
    var totalOffTakePmftc = 0.0
    var totalProfitPmftc = 0.0
    
    
    var totalOffTakerOthers = 0.0
    var totalProfitOthers = 0.0
    
    var totalCigarettes = 0.0
    var totalProfit = 0.0
    
    var rewardsTotal = 0.0
    var pmftcRewardsTotal = 0.0
    var othersRewardsTotal = 0.0
    
    func start() {
        isLoading.value = true
        
        var text = ""
        
        if inputType == .offtake {
            if userType == .retailer {
                text = "Ito ang mga binebenta kong RETAIL PACKS ng sigarilyo"
            }else if userType == .wholeSaler {
                text = "Ito ang mga binebenta kong WHOLESALE CARTONS ng sigarilyo"
            }
        }else {
            if userType == .retailer {
                text = "Ito ang nakukuha kong REWARDS in PESO as a RETAILER"
            }else if userType == .wholeSaler {
                text = "Ito ang nakukuha kong REWARDS in PESO as a WHOLESALER"
            }
        }

        
        updatesTopHeaderText?(text)
    }
    
    func fetch() {
        switch inputType {
        case .offtake:
            let pmftcInputViewModel = PmftcInputViewModel()
            let pmftcSecondInputViewModel = PmftcSecondInputViewModel()
            let otherBrandsInputViewModel = OtherBrandsInputViewModel()
            
            pmftcInputViewModel.start(items: items)
            pmftcSecondInputViewModel.start(items: items)
            otherBrandsInputViewModel.start(items: items)
            
            pmftcInputViewModel.isUpdatingValue.addObserver(fireNow: false) { (isUpdating) in
                self.compute()
            }
            
            pmftcSecondInputViewModel.isUpdatingValue.addObserver(fireNow: false) { (isUpdating) in
                self.compute()
            }
            
            otherBrandsInputViewModel.isUpdatingValue.addObserver(fireNow: false) { (isUpdating) in
                self.compute()
            }
            
            tableViewModels.value = [pmftcInputViewModel, pmftcSecondInputViewModel, otherBrandsInputViewModel]
        default:
            let pmftcInputViewModel = PmftcInputRewardsViewModel(userType: userType)
            let pmftcSecondInputViewModel = PmftcSecondInputRewardsViewModel(userType: userType)
            let otherBrandsInputViewModel = OtherBrandsInputRewardsViewModel(userType: userType)
            
            pmftcInputViewModel.start()
            pmftcSecondInputViewModel.start(items: items)
            otherBrandsInputViewModel.start(items: items)
            
            pmftcInputViewModel.isUpdatingValue.addObserver(fireNow: false) { (isUpdating) in
                self.compute()
            }
            
            pmftcSecondInputViewModel.isUpdatingValue.addObserver(fireNow: false) { (isUpdating) in
                self.compute()
            }
            
            otherBrandsInputViewModel.isUpdatingValue.addObserver(fireNow: false) { (isUpdating) in
                self.compute()
            }
            
            tableViewModels.value = [pmftcInputViewModel, pmftcSecondInputViewModel, otherBrandsInputViewModel]
        }
        
        isLoading.value = false
    }

    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is TextFieldCellViewModel:
            return TextFieldTableViewCell.nibName
        case is ButtonTableViewCellViewModel:
                return ButtonTableViewCell.nibName
        case is ImageCellViewModel:
               return ImageTableViewCell.nibName
        case is RadioButtonTableViewCellViewModel:
                return RadioButtonTableViewCell.nibName
        case is AutoComputeTextFieldCellViewModel:
                return AutoComputeTextFieldTableViewCell.nibName
        case is VerticalAlignLabelTemplateTableViewCellViewModel:
                return VerticalAlignLabelTemplateTableViewCell.nibName
       case is TitleWithSubTitleTemplateTableViewCellViewModel:
               return TitleWithSubTitleTemplateTableViewCell.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    func getTableViewModel(tag: Int) -> TableViewConfigurable{
        
        if tableViewModels.value.count > 2 {
            switch tag {
             case 1001:
                 return tableViewModels.value[0]
             case 1002:
                 return tableViewModels.value[1]
             case 1003:
                 return tableViewModels.value[2]
             default:
                 return tableViewModels.value[0]
             }
        }
 
        
        return EmptyConfigurable()
    }
    
    func validate() {
        self.proceed?()
    }
    
    
    func compute() {
        if let firstPmftc = tableViewModels.value.first as? PmftcInputViewModel, let secondPmftc = tableViewModels.value[1] as? PmftcSecondInputViewModel, let othersBrand = tableViewModels.value[2] as? OtherBrandsInputViewModel {
            totalProfitPmftc = firstPmftc.sumValue + secondPmftc.sumValue
            totalOffTakePmftc = firstPmftc.offTake + secondPmftc.offTake
            
            totalProfitOthers = othersBrand.sumValue
            totalOffTakerOthers = othersBrand.offTake
            
            totalProfit = totalProfitPmftc + totalProfitOthers
            totalCigarettes = (totalOffTakePmftc + totalOffTakerOthers) * 20
        }
        
        if let firstPmftc = tableViewModels.value.first as? PmftcInputRewardsViewModel, let secondPmftc = tableViewModels.value[1] as? PmftcSecondInputRewardsViewModel, let othersBrand = tableViewModels.value[2] as? OtherBrandsInputRewardsViewModel {
            pmftcRewardsTotal = firstPmftc.sumValue + secondPmftc.sumValue
            othersRewardsTotal = othersBrand.sumValue
            rewardsTotal = pmftcRewardsTotal + othersRewardsTotal
        }
        
        
        self.isUpdatingValue.value = true
    }
}


class EmptyConfigurable: TableViewConfigurable {
    var sectionViewModels: Observable<[SectionViewModel]> = Observable<[SectionViewModel]>(value: [])
}
