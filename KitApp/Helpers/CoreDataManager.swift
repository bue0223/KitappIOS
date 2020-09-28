//
//  CoreDataManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    
    func savePriceProgram(program: PriceProgram, downloadCompleted: @escaping () -> Void) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        var itemsWithImagesCount: Int {
            return 1
        }
        
        var downloadCount = 0 {
            didSet {
                if downloadCount == itemsWithImagesCount {
                    downloadCompleted()
                }
            }
        }
        
        let firstProgram = PriceProgramItemEntity(context: managedContext)
        firstProgram.carton_price = program.first_row?.carton_price ?? 0.0
        firstProgram.label = program.first_row?.label
        firstProgram.type = program.type
        firstProgram.row = 1
        firstProgram.is_reward = false
        firstProgram.image_url = program.first_row?.image ?? ""
        firstProgram.is_shown = Int64(program.is_shown ?? 0)
        
        if let url = URL(string: program.first_row?.image ?? "") {
            ApiClient().download(url: url) { (result) in
                downloadCount = downloadCount + 1
                switch result {
                case .success(let value):
                    guard let image = UIImage(data: value) else {
                        print("Error while converting the image data to a UIImage")
                        return
                    }

                    firstProgram.image = image.pngData() ?? Data()
                    try? managedContext.save()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        let secondProgram = PriceProgramItemEntity(context: managedContext)
        secondProgram.carton_price = program.second_row?.carton_price ?? 0.0
        secondProgram.label = program.second_row?.label
        secondProgram.percentage_value = program.second_row?.percentage_value ?? 0.0
        secondProgram.percentage_label = program.second_row?.percentage_label ?? ""
        secondProgram.row = 2
        secondProgram.type = program.type
        secondProgram.is_reward = true
        secondProgram.is_shown = Int64(program.is_shown ?? 0)
        
        let thirdProgram = PriceProgramItemEntity(context: managedContext)
        thirdProgram.carton_price = program.third_row?.carton_price ?? 0.0
        thirdProgram.label = program.third_row?.label
        thirdProgram.percentage_value = program.third_row?.percentage_value ?? 0.0
        thirdProgram.percentage_label = program.third_row?.percentage_label ?? ""
        thirdProgram.row = 3
        thirdProgram.type = program.type
        thirdProgram.is_reward = true
        thirdProgram.is_shown = Int64(program.is_shown ?? 0)
        
        let fourthProgram = PriceProgramItemEntity(context: managedContext)
        fourthProgram.carton_price = program.fourth_row?.carton_price ?? 0.0
        fourthProgram.label = program.fourth_row?.label
        fourthProgram.percentage_value = program.fourth_row?.percentage_value ?? 0.0
        fourthProgram.percentage_label = program.fourth_row?.percentage_label ?? ""
        fourthProgram.row = 4
        fourthProgram.type = program.type
        fourthProgram.is_reward = true
        fourthProgram.is_shown = Int64(program.is_shown ?? 0)
        
        let fifthProgram = PriceProgramItemEntity(context: managedContext)
        fifthProgram.carton_price = program.fifth_row?.carton_price ?? 0.0
        fifthProgram.label = program.fifth_row?.label
        fifthProgram.percentage_value = program.fifth_row?.percentage_value ?? 0.0
        fifthProgram.percentage_label = program.fifth_row?.percentage_label ?? ""
        fifthProgram.row = 5
        fifthProgram.type = program.type
        fifthProgram.is_reward = true
        fifthProgram.is_shown = Int64(program.is_shown ?? 0)
        
        let sixthProgram = PriceProgramItemEntity(context: managedContext)
        sixthProgram.carton_price = program.sixth_row?.carton_price ?? 0.0
        sixthProgram.label = program.sixth_row?.label
        sixthProgram.percentage_value = program.sixth_row?.percentage_value ?? 0.0
        sixthProgram.percentage_label = program.sixth_row?.percentage_label ?? ""
        sixthProgram.row = 6
        sixthProgram.type = program.type
        sixthProgram.is_reward = false
        sixthProgram.is_shown = Int64(program.is_shown ?? 0)
        
        try? managedContext.save()
        
        if (program.first_row?.image ?? "").isEmpty == true {
            downloadCompleted()
        }
        
    }
    
    func savePricePrograms(programs: [PriceProgram], downloadCompleted: @escaping () -> Void) {
        var downloadCount = 0 {
            didSet {
                if downloadCount == 2 {
                    downloadCompleted()
                }
            }
        }
                
        for program in programs {
            savePriceProgram(program: program) {
                downloadCount = downloadCount + 1
            }
        }
    }
    
    func saveProducts(products: [Product], downloadCompleted: @escaping () -> Void) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        
        let itemsWithImages = products.filter { (product) -> Bool in
            return (product.image ?? "").isEmpty == false
        }
        
        var downloadCount = 0 {
            didSet {
                if downloadCount == itemsWithImages.count {
                    downloadCompleted()
                }
            }
        }
        
        for product in products {
            let productEntity = ProductEntity(context: managedContext)
            productEntity.id = product.id
            productEntity.category = product.category
            productEntity.name = product.name
            productEntity.pack_price_wholesale = product.wholesale?.pack_price ?? 0.0
            productEntity.pack_price_retail = product.retail?.pack_price ?? 0.0
            productEntity.ream_price_wholesale =  product.wholesale?.carton_price ?? 0.0
            productEntity.ream_price_retail = product.retail?.carton_price ?? 0.0
            productEntity.stick_price = product.retail?.stick_price ?? 0.0
            productEntity.stick_price_wholesale = product.wholesale?.stick_price ?? 0.0
            productEntity.quantity_per_pack = 10
            productEntity.ave_weekly_packs = Int64(product.ave_weekly_packs ?? 0)
            productEntity.ave_weekly_cartons = Int64(product.ave_weekly_cartons ?? 0)
            productEntity.is_product = true
            productEntity.order = Int64(product.order ?? 0)
            productEntity.image_url = product.image
            
            if product.name?.lowercased() == "marlboro" {
                productEntity.product_order = 1
            }else if product.name?.lowercased() == "fortune" {
                productEntity.product_order = 2
            }else if product.name?.lowercased() == "philip morris" {
                productEntity.product_order = 3
            }else {
                productEntity.product_order = 10
            }
            
            var rewardsEntities: [RewardEntity] = []
            
            for reward in (product.rewards ?? []) {
                let rewardEntity = RewardEntity(context: managedContext)
                rewardEntity.reward = Double(reward.reward ?? 1)
                rewardEntity.type = reward.type
                rewardEntity.owner = productEntity
                
                rewardsEntities.append(rewardEntity)
            }
            
            productEntity.rewards = NSSet(array: rewardsEntities)
            
            if let url = URL(string: product.image ?? "") {
                ApiClient().download(url: url) { (result) in
                    downloadCount = downloadCount + 1

                    switch result {
                    case .success(let value):
                        guard let image = UIImage(data: value) else {
                            print("Error while converting the image data to a UIImage")
                            return
                        }

                        productEntity.image = image.pngData() ?? Data()
                        try? managedContext.save()
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }

            try? managedContext.save()
        }
    }
    
    func saveMessages(messages: [Message], downloadCompleted: @escaping () -> Void) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        for message in messages {
            let messageEntity = MessageEntity(context: managedContext)
            messageEntity.id = message.id
            messageEntity.screen_title = message.screen_title
            messageEntity.page = message.page
            messageEntity.content = message.content
            
            try? managedContext.save()
        }

        downloadCompleted()
    }
    
    func saveInfoGraphics(items: [InfoGraphics], infoImagesDownloadComplate: @escaping () -> (), psspImagesDownloadComplete: @escaping () -> (), videoDownloadComplete: @escaping () -> ()) {

        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let infoImagesWithImage = (items.first?.images ?? []).filter { (infoImage) -> Bool in
            return infoImage.image.isEmpty == false
        }
        
        let psspImagesWithImage = (items.first?.pssp ?? []).filter { (psspItem) -> Bool in
            return (psspItem.image ?? "").isEmpty == false
        }
        
        var downloadInfoImageCount = 0 {
                  didSet {
                    if downloadInfoImageCount == infoImagesWithImage.count {
                                    infoImagesDownloadComplate()
                       }
                }
        }
        
        if infoImagesWithImage.count == 0 {
             infoImagesDownloadComplate()
        }
        
        var downloadPsspImageCount = 0 {
                  didSet {
                    if downloadPsspImageCount == psspImagesWithImage.count {
                                    psspImagesDownloadComplete()
                       }
                }
        }
        
        if psspImagesWithImage.count == 0 {
            psspImagesDownloadComplete()
        }
            
        for infoGraphicItem in items {
            let infoGraphicEntity = InfoGraphicsEntity(context: managedContext)
            infoGraphicEntity.id = infoGraphicItem.id
            infoGraphicEntity.video_url = infoGraphicItem.video_url
            
            if infoGraphicItem.video_url.isEmpty == true {
                videoDownloadComplete()
            }
            
            if let url = URL(string: infoGraphicItem.video_url) {
                ApiClient().download(url: url) { (result) in


                    switch result {
                    case .success(let value):
                        infoGraphicEntity.video = value
                        videoDownloadComplete()
                        let path = self.getDocumentsDirectory().appendingPathComponent("infographic.mp4")

                        try? value.write(to: path)
                        
                        print("Path: \(path)")

                        infoGraphicEntity.video_url = path.absoluteString

                        try? managedContext.save()
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            
            
            var infoImagesEntites: [InfoImageEntity] = []
            var productPsspEntities: [PsspProductEntity] = []
            
            for infoImageItem in infoGraphicItem.images {
                let infoImageEntity = InfoImageEntity(context: managedContext)
                infoImageEntity.caption = infoImageItem.caption
                infoImageEntity.owner = infoGraphicEntity
                infoImageEntity.index = Int64(infoImageItem.index)
                infoImageEntity.image_url = infoImageItem.image
                
                if let url = URL(string: infoImageItem.image) {
                    ApiClient().download(url: url) { (result) in
                        downloadInfoImageCount = downloadInfoImageCount + 1
                        switch result {
                        case .success(let value):
                            infoImageEntity.image = value
                            try? managedContext.save()
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                
                infoImagesEntites.append(infoImageEntity)
                
                
                let popupContent = PopupContentEntity(context: managedContext)
                popupContent.desc = infoImageItem.popup_content?.popup_image_description
                popupContent.owner = infoImageEntity
                

                infoImageEntity.popupcontent = popupContent
            }
            
            for psspItem in (infoGraphicItem.pssp ?? []) {
                let psspProductEntity = PsspProductEntity(context: managedContext)
                psspProductEntity.stick_price = psspItem.stick_price ?? 0.0
                psspProductEntity.pack_price = psspItem.pack_price ?? 0.0
                psspProductEntity.owner = infoGraphicEntity
                psspProductEntity.image_url = psspItem.image
                psspProductEntity.order = Int64(psspItem.order ?? 0)
                
                if let url = URL(string: psspItem.image ?? "") {
                    ApiClient().download(url: url) { (result) in
                        downloadPsspImageCount = downloadPsspImageCount + 1
                        switch result {
                        case .success(let value):
                            psspProductEntity.image = value
                            try? managedContext.save()
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                
                productPsspEntities.append(psspProductEntity)
            }
            
            infoGraphicEntity.psspItems = NSSet(array: productPsspEntities)
            
            infoGraphicEntity.infoimages = NSSet(array: infoImagesEntites)

            try? managedContext.save()
        }
    }
    
    func fetch<T: NSFetchRequestResult>(isProducts: Bool = false, isPriceProgram: Bool = false) -> [T]? {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return nil }
                
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        if isProducts == true {
            let productSort = NSSortDescriptor(key: "order", ascending:true)
            fetchRequest.sortDescriptors = [productSort]
        }
        
        if isPriceProgram == true {
            let rowSort = NSSortDescriptor(key: "row", ascending:true)
            fetchRequest.sortDescriptors = [rowSort]
        }
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            return nil
        }
    }
    
    func delete(entityName: String) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
