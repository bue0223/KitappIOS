//
//  LoginViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/7/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

let appDelegate = UIApplication.shared.delegate as? AppDelegate


enum InputValueType {
    case userType
    case storeName
    case ownerName
    case ownerType
    case displayImage
}

class LoginViewModel {
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
    
    var proceed: (() -> Void)?
    
    var firstRadioButtonPressed: (() -> Void)?
    
    var secondRadioButtonPressed: (() -> Void)?
    
    var userCategories = ["BBE", "WHEX", "VSM Luzon", "VSM VisMin"]
    
    var selectedDropDownItemForUsertype = Observable<String>(value: "")
    
    
    var selectedDropDownIndex: ( (_ index: Int) -> Void)?
    
    var inputs: [InputValueType: String] = [:] 
    
    var isLoading = Observable<Bool>(value: false)
    
    
    var enableButtons = Observable<Bool>(value: false)
    
    var contentManager: ContentManager
    
    
    var openDropDownView: (() -> Void)?
    
    
    var benefitVideoButtonPressed: (() -> ())?
    var tradeProgramsButtonPressed: (() -> ())?
    var productsButtonPressed: (() -> ())?
    
    
    var proceedProductsPriceList: (() -> ())?
    var proceedTradePrograms: (() -> ())?
    
    var proceedBenefitVideo: (() -> ())?
    
    
    var isConnectedToInternet: Bool = false
    
    var shouldProceedLogin: Bool = false {
        didSet {
            if shouldProceedLogin == true {
                //isLoading.value = true
                if completedProductsDownload == true {
                    isLoading.value = false
                    self.proceed?()
                }
            }
        }
    }
    
    var shouldProceedPricelist: Bool = false {
        didSet {
            if shouldProceedPricelist == true {
                //isLoading.value = true
                if completedProductsDownload == true {
                    isLoading.value = false
                    self.proceedProductsPriceList?()
                }
            }

        }
    }
    
    var shouldProceedBenefitVideo: Bool = false {
        didSet {
            if shouldProceedBenefitVideo == true {
               // isLoading.value = true
                if completedBenefitVideoDownload == true {
                    isLoading.value = false
                    self.proceedBenefitVideo?()
                }
            }

        }
    }
    
    var shouldProceedTradePrograms: Bool = false {
        didSet {
            if shouldProceedTradePrograms == true {
                //isLoading.value = true
                if completedInfoGraphicsDownload == true {
                    isLoading.value = false
                    self.proceedTradePrograms?()
                }
            }
        }
    }
    
    var completedProductsDownload: Bool = true {
        didSet {
            if shouldProceedLogin == true {
                self.proceed?()
                return
            }
            
            if shouldProceedPricelist == true {
                self.proceedProductsPriceList?()
                return
            }
        }
    }
    
    var completedInfoGraphicsDownload: Bool = true {
        didSet {
            if shouldProceedTradePrograms == true {
                self.proceedTradePrograms?()
            }
        }
    }
    
    var completedBenefitVideoDownload: Bool = true {
        didSet {
            if shouldProceedBenefitVideo == true {
                self.proceedBenefitVideo?()
                return
            }
        }
    }
    
    var presentPopUpWithTransaction: ((_ transaction: @escaping () -> Void) -> Void )?
    
    init(contentManager: ContentManager = ContentManager()) {
        self.contentManager = contentManager
    }
    
    func start() {
        inputs[.ownerType] = nil
        //inputs[.userType] = nil
        inputs[.ownerName] = nil
        inputs[.storeName] = nil

        
        let imageViewModel = ImageCellViewModel(name: "logo")
        
        let userTypeViewModel = TextFieldCellViewModel(text: Observable<String>(value: inputs[.userType] ?? ""), isButtonType: true)
        userTypeViewModel.type = .userType
        
        userTypeViewModel.buttonPressed = {
            self.openDropDownView?()
        }
        
        let storeNameViewModel = TextFieldCellViewModel(text: Observable<String>(value: ""), enabled: Observable<Bool>(value: false))
        storeNameViewModel.type = .storeName
        
        let ownerNameViewModel = TextFieldCellViewModel(text: Observable<String>(value: ""), enabled: Observable<Bool>(value: false))
        ownerNameViewModel.type = .ownerName
        
        let radioButtonTableViewCellViewModel = RadioButtonTableViewCellViewModel(text: Observable<String>(value: "START"), enabled: Observable<Bool>(value: false))
        
        let buttonCellViewModel = ButtonTableViewCellViewModel(text: Observable<String>(value: "Start"))
        buttonCellViewModel.enabled.value = false

        radioButtonTableViewCellViewModel.firstButtonPressed = {
            self.firstRadioButtonPressed?()
            
            self.inputs[.ownerType] = "wholesaler"
            
            buttonCellViewModel.enabled.value = self.validate()
            self.enableButtons.value = self.validate()
            
        }
        
        radioButtonTableViewCellViewModel.secondButtonPressed = {
            self.secondRadioButtonPressed?()
            
            self.inputs[.ownerType] = "retailer"
            
            buttonCellViewModel.enabled.value = self.validate()
            
            self.enableButtons.value = self.validate()
        }
        
        selectedDropDownItemForUsertype.addObserver(fireNow: false) { (userCagetorySelected) in
         
            userTypeViewModel.text.value = userCagetorySelected
            self.inputs[.userType] = userCagetorySelected
            
            if userCagetorySelected.lowercased() == "WHEX".lowercased() {
                radioButtonTableViewCellViewModel.isAutoPickFirstItem.value = true
            }else {
                radioButtonTableViewCellViewModel.isAutoPickFirstItem.value = false
            }
            
            radioButtonTableViewCellViewModel.enabled.value = true
            storeNameViewModel.enabled.value = true
            ownerNameViewModel.enabled.value = true
            buttonCellViewModel.enabled.value = self.validate()
            self.enableButtons.value = self.validate()
        }
        
        storeNameViewModel.text.addObserver(fireNow: false) { (text) in
            self.inputs[.storeName] = text
            buttonCellViewModel.enabled.value = self.validate()
            self.enableButtons.value = self.validate()
        }
        
        ownerNameViewModel.text.addObserver(fireNow: false) { (text) in
            self.inputs[.ownerName] = text
            buttonCellViewModel.enabled.value = self.validate()
            self.enableButtons.value = self.validate()
        }
        
        buttonCellViewModel.buttonPressed = {
            self.createUser()
            self.shouldProceedLogin = true
        }
        
        radioButtonTableViewCellViewModel.enabled.value = inputs[.userType] != nil
        storeNameViewModel.enabled.value = inputs[.userType] != nil
        ownerNameViewModel.enabled.value = inputs[.userType] != nil
        
        sectionViewModels.value = [SectionViewModel(rowViewModels: [imageViewModel, userTypeViewModel, storeNameViewModel, ownerNameViewModel, radioButtonTableViewCellViewModel, buttonCellViewModel], headerTitle: "")]
            
        
        selectedDropDownIndex = { index in
            self.selectedDropDownItemForUsertype.value = self.userCategories[index]
        }
        
        updateData()
        
        
        productsButtonPressed = {
                print("Products Images download complete")
 
            self.shouldProceedPricelist = true
        }
        
        tradeProgramsButtonPressed = {

                print("Info graphics images complete")
            self.shouldProceedTradePrograms = true
        }
        
        
        benefitVideoButtonPressed = {

                print("Info graphics images complete")

            self.shouldProceedBenefitVideo = true
        }
        
        
        DownloadManager.shared.startCheckIfDownloadNeeded()
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
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
    func createUser() {
        let user = User(userType: inputs[.ownerType] ?? "", name: inputs[.ownerName] ?? "", storeName: inputs[.storeName] ?? "", categoryType: inputs[.userType] ?? "")
        
        UserManager().setUser(user: user)
    }
    
    func validate() -> Bool {        
        if inputs.count < 4 {
            return false
        }
        
        for input in inputs {
            if input.value.isEmpty == true {
                return false
            }
        }
        
        return true
    }
    
    
    var reachability: Reachability!
    

    
    func updateData() {
        do {
            reachability = Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability.startNotifier()
        } catch {
            print("This is not working.")
        }
    }
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        let reachability = note.object as! Reachability
        
        isConnectedToInternet = reachability.connection != .none
        if reachability.connection != .none {
            DownloadManager.shared.startCheckIfDownloadNeeded()
        } else {
            checkInternet()
        }
    }
    
    fileprivate func checkInternet() {
        if SessionManager.shared.loadChangeIdentifier() == nil {
            transactWithInternetAvailabilityAlert(transaction: {
                DownloadManager.shared.startCheckIfDownloadNeeded()
            })
        }
    }
    
    func transactWithInternetAvailabilityAlert(transaction: ( () -> Void)?, backButtonHandler: (()->())? = nil){
        if reachability.connection != .none {
            transaction?()
        }else {
            presentPopUpWithTransaction? {
                self.transactWithInternetAvailabilityAlert(transaction: transaction)
            }
        }
    }
    

}
