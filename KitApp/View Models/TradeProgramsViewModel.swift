//
//  TradeProgramsViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/27/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation


class TradeProgramsViewModel {
    let sectionViewModels = Observable<[SectionViewModel]>(value: [])
    
//    var isFirstScreen: Bool = true {
//        didSet {
//            start()
//        }
//    }
    
    var proceed: (() -> Void)?
    
    var inputs: [InputValueType: String] = [:]
    
    var isLoading = Observable<Bool>(value: false)
    
    var contentManager: ContentManagerProtocol
    
    var viewInfoImage: ((_ infoImage: InfoImageEntity) -> Void)?
    
    var contentTitle: String {
        return messages.filter { (message) -> Bool in
            return message.page == "5"
            }.first?.content ?? "Handa kana ba maging ALL-IN sa negosyo?"
    }
    
    var messages: [MessageEntity] = CoreDataManager().fetch(isProducts: false) ?? []
    
    var updatesContentHeader: ((_ text: String) -> ())?
    
    init(contentManager: ContentManagerProtocol = ContentManager()) {
        self.contentManager = contentManager
    }
    
    func start() {
        updatesContentHeader?(contentTitle)
        
        let items: [InfoGraphicsEntity] = (CoreDataManager().fetch(isProducts: false) ?? [])
        var rowViewModels: [RowViewModel] = []
        
        var infoImages: [InfoImageEntity] = []
 
            infoImages = (items.first?.infoimages?.map({ (item) -> InfoImageEntity in
                return (item as! InfoImageEntity)
            }) ?? [])
                .sorted(by: { (a, b) -> Bool in
                    return a.index < b.index
                })
    
        var counter = 0
        for item in infoImages {
            if let infoImage = item as? InfoImageEntity {
                var diskImage = ""
                
                if counter == 0 {
                    diskImage = "round-yellow"
                }
                
                if counter == 1 {
                    diskImage = "round-red"
                }
                
                if counter == 2 {
                    diskImage = "round-bluegreen"
                }
                
                if counter == 3 {
                    diskImage = "round-yellow"
                }
                
                if counter == 4 {
                    diskImage = "round-red"
                }
                
                if counter == 5 {
                    diskImage = "round-yellow"
                }
                
                if counter == 6 {
                    diskImage = "round-red"
                }
                
                if counter == 7 {
                    diskImage = "round-bluegreen"
                }
                
                if counter == 8 {
                    diskImage = "round-yellow"
                }
                
                if counter == 9 {
                    diskImage = "round-red"
                }
                
                
                let infoImageViewModel = InfoImageCollectionViewCellViewModel(model: infoImage, isLeaningUp: counter % 2 == 0, diskImage: diskImage )
                
                infoImageViewModel.cellPressed = {
                    self.viewInfoImage?(infoImage)
                }
                
                rowViewModels.append(infoImageViewModel)
            }
            
            counter = counter + 1
        }
        
        sectionViewModels.value = [SectionViewModel(rowViewModels: rowViewModels, headerTitle: "")]
        
    }
    
    func cellIdentifier(for viewModel: RowViewModel) -> String {
        switch viewModel {
        case is InfoImageCollectionViewCellViewModel:
            return InfoImageCollectionViewCell.nibName
        default:
            fatalError("Unexpected view model type: \(viewModel)")
        }
    }
}
