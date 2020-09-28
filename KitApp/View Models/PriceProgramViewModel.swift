//
//  PriceProgramViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class PriceProgramViewModel {
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
    //var isUpdatingValue = Observable<Bool>(value: false)
    
    var proceed: (() -> Void)?
    
    var isLoading = Observable<Bool>(value: false)
    
    var userType: UserType = .retailer
    
    
    var playLeftConfetti: (() -> Void)?
    var playRightConfetti: (() -> Void)?
    var playBothConfetti: (() -> Void)?
    
    var confettiPlayed: Bool = false
    func start() {
        let isRetailer = UserManager().user?.userType == "retailer"
        
        let items: [PriceProgramItemEntity] = (CoreDataManager().fetch(isPriceProgram: true) ?? []).filter { (priceProgramEntity) -> Bool in
            
            if isRetailer == true {
                return priceProgramEntity.type == "RETAIL"
            }else {
                return priceProgramEntity.type == "WHOLESALE"
            }
        }
        
        var rowViewModels: [RowViewModel] = []
        
        
        if items.count > 0 {
            
            let textHeadViewModel = PsspHeaderAutoComputeTextFieldCellViewModel(text: Observable<String>(value: ""), displayText: items[5].label)
            
            
            let textViewModel1 = PsspAutoComputeCellViewModel(model: items[0], text: Observable<String>(value: ""))
            
            let textViewModel2 = PsspAutoComputeCellViewModel(model: items[1], text: Observable<String>(value: ""))
            textViewModel2.isUnderlineViewHidden = false
            textViewModel2.rowHeight = 62.0
            
            let textViewModel3 = PsspAutoComputeCellViewModel(model: items[2], text: Observable<String>(value: ""), isInputDisplayed: Observable<Bool>(value: false))
            textViewModel3.rowHeight = 54.0
            let textViewModel4 = PsspAutoComputeCellViewModel(model: items[3], text: Observable<String>(value: ""), isInputDisplayed: Observable<Bool>(value: false))
            let textViewModel5 = PsspAutoComputeCellViewModel(model: items[4], text: Observable<String>(value: ""), isInputDisplayed: Observable<Bool>(value: false))
            
            textViewModel1.text.addObserver(fireNow: false) { (text) in
                // self.compute()
                
                let textStripped = text.replacingOccurrences(of: ",", with: "")
                
                let doubleValue = Double(textStripped) ?? 0.0
                
                
                if doubleValue > 0 {
                    if self.confettiPlayed == false {
                        self.playBothConfetti?()
                        self.confettiPlayed = true
                    }
                }else {
                    self.confettiPlayed = false
                }
                
                // Note: - Hidden temporary
                //                if doubleValue == 0.0 {
                //                    textViewModel3.isInputDisplayed.value = false
                //                    textViewModel4.isInputDisplayed.value = false
                //                    textViewModel5.isInputDisplayed.value = false
                //                }
                
                // Note: - Hidden temporarily
                // textViewModel3.isCheckButtonEnabled.value = text.isEmpty == false && doubleValue > 0.0
                //textViewModel4.isCheckButtonEnabled.value = text.isEmpty == false && doubleValue > 0.0
                
                self.compute(quantityTotal: Decimal(string: textStripped) ?? 0, firstRow: textViewModel1, rows: [textViewModel2, textViewModel3, textViewModel4, textViewModel5], header: textHeadViewModel)
            }
            
            textViewModel3.isInputDisplayed.addObserver(fireNow: false) { (isDisplayed) in
                textViewModel5.isInputDisplayed.value = (isDisplayed == true && textViewModel4.isInputDisplayed.value == true)
                
                
                let textStripped = textViewModel1.text.value.replacingOccurrences(of: ",", with: "")
                
                self.compute(quantityTotal: Decimal(string: textStripped) ?? 0, firstRow: textViewModel1, rows: [textViewModel2, textViewModel3, textViewModel4, textViewModel5], header: textHeadViewModel)
                
                // Note: - Hidden temporarily
                if self.confettiPlayed == true {
                    if textViewModel5.isInputDisplayed.value == true {
                        self.playBothConfetti?()
                    }else if isDisplayed == true {
                        self.playLeftConfetti?()
                    }
                }
            }
            
            textViewModel4.isInputDisplayed.addObserver(fireNow: false) { (isDisplayed) in
                
                textViewModel5.isInputDisplayed.value = (isDisplayed == true && textViewModel3.isInputDisplayed.value == true)
                
                let textStripped = textViewModel1.text.value.replacingOccurrences(of: ",", with: "")
                self.compute(quantityTotal: Decimal(string: textStripped) ?? 0, firstRow: textViewModel1, rows: [textViewModel2, textViewModel3, textViewModel4, textViewModel5], header: textHeadViewModel)
                
                // Note: - Hidden temporarily
                if self.confettiPlayed == true {
                    if textViewModel5.isInputDisplayed.value == true {
                        self.playBothConfetti?()
                    }else if isDisplayed == true {
                        self.playRightConfetti?()
                    }
                }
            }
            
            let sectionViewModel = PriceProgramSectionHeaderViewModel(imageData: textViewModel1.imageData)
            
            rowViewModels.append(textHeadViewModel)
            rowViewModels.append(sectionViewModel)
            rowViewModels.append(textViewModel1)
            rowViewModels.append(textViewModel2)
            rowViewModels.append(textViewModel3)
            rowViewModels.append(textViewModel4)
            rowViewModels.append(textViewModel5)
            
            textViewModel3.isCheckButtonEnabled.value = true
            textViewModel3.isInputDisplayed.value = true
            textViewModel4.isCheckButtonEnabled.value = true
            textViewModel4.isInputDisplayed.value = true
            
            sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "")]
        }
        
    }
    
    
    func compute(quantityTotal: Decimal, firstRow: PsspAutoComputeCellViewModel,  rows: [PsspAutoComputeCellViewModel], header: PsspHeaderAutoComputeTextFieldCellViewModel)  {
        
        //if confettiPlayed == true {
        var totalRewards: Decimal = 0.0
        var totalQuantity: Decimal = 0.0
        
        var totalRewardsDisplay: Decimal = 0.0
        var totalQuantityDisplay: Decimal = 0.0
        for row in rows {
            if row.isInputDisplayed.value == true {
                
                let percentageDecimal: Decimal = Decimal((row.model?.percentage_value ?? 0.0) / 100)
                
                var itemQuantityDecimal: Decimal = quantityTotal * percentageDecimal
                
                var roundedQuantity = Decimal()
                let itemQuantityDecimalRounded: Void = NSDecimalRound(&roundedQuantity, &itemQuantityDecimal, 1, .plain)

                print("Quantity: \(quantityTotal)")
                
                let cartonPrice = Decimal(row.model?.carton_price ?? 0.0)
                
                
                
                let formatted = formatNumberDecimalToRetainOneDecimal(roundedQuantity) ?? "0.0"
                row.text.value = formatted
                let itemTotal = roundedQuantity * cartonPrice
                
                totalRewards = totalRewards + itemTotal
                totalQuantity = totalQuantity + roundedQuantity
                
                if totalQuantity == 0.0 {
                    row.text.value = ""
                    row.subText.value = ""
                    row.subValue = 0.0
                    
                    totalRewardsDisplay = totalRewardsDisplay + 0
                    totalQuantityDisplay = totalQuantityDisplay + 0
                    
                }else {
                    let itemTotalFormatted = itemTotal.formattedAmount
                    row.subText.value = itemTotalFormatted
                    row.subValue = itemTotal
//                    print("Row Compute CalledZ")
                    if row.model?.row == 5 {
                       // print("Row 5 Called")
                        
                        let cartonePrice = Decimal( firstRow.model?.carton_price ?? 0.0 )
                        let firstRowValue: Decimal = cartonePrice * quantityTotal
                        print("First Row Value: \(firstRowValue)")
                        
                        let secondRowValue = rows.filter { (autoViewModel) -> Bool in
                            return autoViewModel.model?.row == 2
                        }.first?.subValue ?? 0.0
                        
                        let secondRowQuantity = Decimal(string: rows.filter { (autoViewModel) -> Bool in
                            return autoViewModel.model?.row == 2
                        }.first?.text.value.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0
                        
                        print("Second Row Value: \(secondRowQuantity)")
                        let thirdRowValue = rows.filter { (autoViewModel) -> Bool in
                            return autoViewModel.model?.row == 3
                        }.first?.subValue ?? 0.0
                        
                        let thirdRowQuantity = Decimal(string: rows.filter { (autoViewModel) -> Bool in
                            return autoViewModel.model?.row == 3
                        }.first?.text.value.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0
                        
                        print("Third Row Value: \(thirdRowQuantity)")
                        let fourthRowValue = rows.filter { (autoViewModel) -> Bool in
                            return autoViewModel.model?.row == 3
                        }.first?.subValue ?? 0.0
                        
                        let fourthRowQuantity = Decimal(string: rows.filter { (autoViewModel) -> Bool in
                            return autoViewModel.model?.row == 4
                            }.first?.text.value.replacingOccurrences(of: ",", with: "") ?? "0.0") ?? 0
                        
                        print("Fourth Row Value: \(fourthRowQuantity)")
                        
                        let consistenctyBonus = firstRowValue - (secondRowValue + thirdRowValue + fourthRowValue)
                        
                        var consistencyQuantity = quantityTotal - (secondRowQuantity + thirdRowQuantity + fourthRowQuantity)
                        
                        var newConsistencyQuantity = consistencyQuantity <= 0 ? 0 : consistencyQuantity
                        print("Consistency: \(consistenctyBonus)")
                        print("Consistency consistencyQuantity: \(consistencyQuantity)")
        
                        var roundedQuantity = Decimal()
                        let itemQuantityDecimalRounded: Void = NSDecimalRound(&roundedQuantity, &newConsistencyQuantity, 1, .plain)
                        
                        row.text.value = formatNumberDecimalToRetainOneDecimal(roundedQuantity) ?? "0.0"
                        row.subText.value = consistenctyBonus.formattedAmount
                        row.subValue = consistenctyBonus
                        
                    }
                    
                    totalRewardsDisplay = totalRewardsDisplay + (row.subValue ?? 0.0)
                    totalQuantityDisplay = totalQuantityDisplay + Decimal((Double(row.text.value.replacingOccurrences(of: ",", with: "")) ?? 0.0))
                
                }
                
                
            }else {
                row.text.value = ""
                row.subText.value = ""
                row.subValue = 0.0
            }
        }
        
        if totalQuantity == 0.0 {
            header.text.value = ""
            header.subText.value = ""
            return
            
        }
        
        header.text.value = formatNumberForComma(totalQuantityDisplay) ?? ""
        header.subText.value = totalRewardsDisplay.formattedAmount
    }
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is PsspHeaderAutoComputeTextFieldCellViewModel:
            return PsspHeaderAutoComputeTextFieldTableViewCell.nibName
        case is PsspAutoComputeCellViewModel:
            return PriceProgramAutoComputeTextFieldTableViewCell.nibName
        case is PriceProgramSectionHeaderViewModel:
            return PriceProgramSectionHeaderTableViewCell.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    func formatNumberDecimalToRetainOneDecimal(_ number: Decimal) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1 // minimum number of fraction digits on right
        formatter.maximumFractionDigits = 1 // maximum number of fraction digits on right, or comment for all available
        formatter.minimumIntegerDigits = 1 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)
        
        let formattedNumber = formatter.string(from: NSNumber.init(value: (number as NSDecimalNumber).floatValue))
        
        return formattedNumber
        
    }
    
    func formatNumberForComma(_ number: Decimal) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0 // minimum number of fraction digits on right
        formatter.maximumFractionDigits = 1 // maximum number of fraction digits on right, or comment for all available
        formatter.minimumIntegerDigits = 0 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)
        
        let formattedNumber = formatter.string(from: NSNumber.init(value: (number as NSDecimalNumber).floatValue))
        
        return formattedNumber
        
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
