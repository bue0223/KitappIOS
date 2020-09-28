//
//  UserManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

class User: Decodable, Serializable {
    var userType: String
    var categoryType: String
    var name: String
    var storeName: String
    var displayImage: Data?
    
    var totalPmtcProfit: Double? = 0.0
    var totalOthersProfit: Double? = 0.0
    
    var totalPmtcRewards: Double? = 0.0
    var totalOthersRewards: Double? = 0.0
    
    var isVsmLuzonUser: Bool {
        return categoryType == "VSM Luzon"
    }
    
    init(userType: String, name: String, storeName: String, categoryType: String) {
        self.userType = userType
        self.name = name
        self.storeName = storeName
        self.categoryType = categoryType
    }
}

class UserManager {
    var user: User? {
        get {
            let model = Disk.retrieve("User", from: .documents, as: User.self)
            return model
        }
    }
    
    func setUser(user: User){
        Disk.store(user, to: .documents, as: "User")
    }
    
    func removeUser() {
        Disk.remove("User", from: .documents)
    }
}
