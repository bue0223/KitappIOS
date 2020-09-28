//
//  InternetManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/24/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class InternetManager {
    func isThereActiveInternetConnection() -> Bool{
        
        if let url = URL(string: "http://www.google.com/m") {
            if (try? Data(contentsOf: url)) != nil {
                return true
            }
        }
    
        return false
    }
}
