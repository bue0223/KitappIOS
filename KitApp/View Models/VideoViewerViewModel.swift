//
//  VideoViewerViewModel.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/17/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class VideoViewerViewModel {
    var contentTitle: String {
        return messages.filter { (message) -> Bool in
            return message.page == "4"
            }.first?.content ?? "Handa kana ba maging ALL-IN sa negosyo?"
    }
    
    var messages: [MessageEntity] = CoreDataManager().fetch(isProducts: false) ?? []
    
    var updatesContentHeader: ((_ text: String) -> ())?
    
    func start(playVideo: @escaping (_ url: String) -> ()) {
          updatesContentHeader?(contentTitle)
          playVideo("infographic.mp4")
          
//        ContentManager().startInfoGraphics(imagesdownloadComplete: {
//            
//        }, videoDownloadComplete: {
//            downloadCompleted()
//        })
    }
}
