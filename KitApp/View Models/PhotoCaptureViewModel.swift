//
//  PhotoCaptureViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class PhotoCaptureViewModel {
    var captureButtonPressed: (() -> Void)?
    var proceed: (() -> Void)?
    
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
    
    var inputs: [InputValueType: UIImage] = [:] {
        didSet {
            //print("Input values: \(inputs)")
        }
    }
    
    var updatesContentHeader: ((_ text: String) -> ())?
    
    var isLoading = Observable<Bool>(value: false)
    
    var contentTitle: String {
        return messages.filter { (message) -> Bool in
            return message.page == "1"
            }.first?.content ?? "Handa kana ba maging ALL-IN sa negosyo?"
    }
    
    var messages: [MessageEntity] = CoreDataManager().fetch(isProducts: false) ?? []
    
    func start() {
        //updatesContentHeader?(contentTitle)
        
        
        let imageCellViewModel = ImageCellViewModel(name: "logo", type: .logo)
        
        let titleCellViewModel = TitleWithSubTitleTemplateTableViewCellViewModel(title: "Hello, \(UserManager().user?.name ?? "")!", subTitle: contentTitle)
        let profileImageCellViewModel = ImageCellViewModel(name: "profile", type: .profile)
        
        let captureButtonCellViewModel = ButtonTableViewCellViewModel(text: Observable<String>(value: "Picture Muna"), buttonType: .Photo)
        captureButtonCellViewModel.buttonPressed = {
            self.captureButtonPressed?()
        }
        let buttonCellViewModel = ButtonTableViewCellViewModel(text: Observable<String>(value: "Continue"), buttonType: .PhotoContinue)

        buttonCellViewModel.enabled.value = true
        
        profileImageCellViewModel.image?.addObserver(fireNow: false, { (image) in
            self.inputs[.displayImage] = image
            
            buttonCellViewModel.enabled.value = true
            //captureButtonCellViewModel.enabled.value = false
        })
                

        buttonCellViewModel.buttonPressed = {
            self.proceed?()
            
            self.updateUser()
        }
        
        
        sectionViewModels.value = [SectionViewModel(rowViewModels: [imageCellViewModel, titleCellViewModel,  profileImageCellViewModel, captureButtonCellViewModel, buttonCellViewModel], headerTitle: "Load load load")]
    }
    
    func validate() -> Bool {
        if inputs.count == 0 {
            return false
        }
        
        return true
    }
    
    func updateUser() {
        if let image = inputs[.displayImage] {
            if let user = UserManager().user {
                user.displayImage = image.jpegData(compressionQuality: 1.0)
                UserManager().setUser(user: user)
              }
        }
    }

    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is TextFieldCellViewModel:
            return TextFieldTableViewCell.nibName
        case is ButtonTableViewCellViewModel:
                return ButtonTableViewCell.nibName
        case is ImageCellViewModel:
            if let viewModel = viewModel as? ImageCellViewModel {
                if viewModel.imageType == .logo {
                    return ImageTableViewCell.nibName
                }
            }
            
               return ProfileImageTableViewCell.nibName
        case is RadioButtonTableViewCellViewModel:
                return RadioButtonTableViewCell.nibName
        case is TitleWithSubTitleTemplateTableViewCellViewModel:
                return TitleWithSubTitleTemplateTableViewCell.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
    
}
