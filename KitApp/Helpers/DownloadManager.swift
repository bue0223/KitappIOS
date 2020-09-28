//
//  DownloadManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/21/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class DownloadManager {
    
    var promptsUserForUpdateOption: (() -> ())?
    var completedDownloading: (() -> ())?
    
    var downloadingProgress: ((_ progress: Double) -> ())?
    
    private init() {}
    
    static let shared = DownloadManager()
    
    var downloadCount: Double = 0.0 {
        didSet {
            print("Download coount: \(downloadCount)")
            
            downloadingProgress?( Double(downloadCount / 6) * 100)
            
            if downloadCount > 5 {
                completedDownloading?()
                print("Completed downloading")
                SessionManager.shared.saveChangeIdentifier(identifier: identifier ?? "")
                
                downloadCount = 0.0
            }
        }
    }
    
    func startCheckIfDownloadNeeded() {
        getContent { (needsUpdate, identifier) in
            self.identifier = identifier
            if needsUpdate == true {
                self.promptsUserForUpdateOption?()
            }
        }
    }
    
    var identifier: String?
    
    func startDownload() {
        self.downloadCount = 0
        
        ContentManager().getMessages {
            self.downloadCount = self.downloadCount + 1
        }
        
        ContentManager().getProducts {
            self.downloadCount = self.downloadCount + 1
        }
        
        ContentManager().getPriceProgram {
            self.downloadCount = self.downloadCount + 1
        }
        
        ContentManager().getInfoGraphics(infoImagesdownloadComplete: {
            self.downloadCount = self.downloadCount + 1
        }, psspImagesdownloadComplete: {
            self.downloadCount = self.downloadCount + 1
        }) {
            self.downloadCount = self.downloadCount + 1
        }
    }
    
    func getContent(completion: @escaping (_ needsUpdate: Bool, _ changeIdentifier: String) -> Void) {
        ApiRouter.content.request { (result: Result<ApiResponse<[ContentVersion]>, Error>) in
            switch result {
            case .success(let value):
                if let identifier = value.payload.first?.api_change_identifier {
                    print("NEEDS UPDATE: \(SessionManager.shared.loadChangeIdentifier() != identifier)")
                    // NOTE: Revert after debug
                    completion(SessionManager.shared.loadChangeIdentifier() != identifier, identifier)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
