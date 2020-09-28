//
//  ContentManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

protocol ContentManagerProtocol {

}

class ContentManager: ContentManagerProtocol {
    
    func getProducts(downloadCompleted: @escaping () -> ()) {
        ApiRouter.getProducts.request { (result: Result<ApiResponse<[Product]>, Error>) in
            CoreDataManager().delete(entityName: "ProductEntity")
            switch result {
            case .success(let value):
                CoreDataManager().saveProducts(products: value.payload, downloadCompleted: downloadCompleted)
            case .failure(let error):
                downloadCompleted()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getMessages(downloadCompleted: @escaping () -> ()) {
        ApiRouter.getMessages.request { (result: Result<ApiResponse<[Message]>, Error>) in
            CoreDataManager().delete(entityName: "MessageEntity")
            switch result {
            case .success(let value):
                CoreDataManager().saveMessages(messages: value.payload, downloadCompleted: downloadCompleted)
            case .failure(let error):
                downloadCompleted()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getInfoGraphics( infoImagesdownloadComplete: @escaping () -> (), psspImagesdownloadComplete: @escaping () -> (), videoDownloadComplete: @escaping () -> ()) {
        ApiRouter.infographics.request { (result: Result<ApiResponse<[InfoGraphics]>, Error>) in
            CoreDataManager().delete(entityName: "InfoGraphicsEntity")
            CoreDataManager().delete(entityName: "InfoImageEntity")
            CoreDataManager().delete(entityName: "PsspProductEntity")
            switch result {
            case .success(let value):
                print("Info graphics: \(value)")
                CoreDataManager().saveInfoGraphics(items: value.payload, infoImagesDownloadComplate: infoImagesdownloadComplete, psspImagesDownloadComplete: psspImagesdownloadComplete, videoDownloadComplete: videoDownloadComplete)
            case .failure(let error):
                infoImagesdownloadComplete()
                psspImagesdownloadComplete()
                videoDownloadComplete()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getPriceProgram(downloadCompleted: @escaping () -> ()) {
        ApiRouter.getPrograms.request { (result: Result<ApiResponse<[PriceProgram]>, Error>) in
             CoreDataManager().delete(entityName: "PriceProgramItemEntity")
            switch result {
            case .success(let value):
                   CoreDataManager().savePricePrograms(programs: value.payload, downloadCompleted: downloadCompleted)
            case .failure(let error):
                downloadCompleted()
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
