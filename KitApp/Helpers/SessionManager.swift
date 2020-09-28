//
//  SessionManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/25/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation
/// This class provides insufficient security for
/// storing customer access token and is provided
/// for sample purposes only. All secure credentials
/// should be stored using Keychain.
///
class SessionManager {
    
    private var accessToken: String?
    
    private var apiChangeIdentifier: String?
    
    private let defaults = UserDefaults.standard
    
    static let shared = SessionManager()
    
    private init() {
        self.loadToken()
    }
    
    private var changeIdkey = "ChangeIdentifier"
    private var authKey = "AuthToken"

    
    func save(accessToken: String) {
        self.accessToken = accessToken
        self.defaults.set(accessToken, forKey: authKey)
        self.defaults.synchronize()
    }
    
    func deleteAccessToken() {
        self.accessToken = nil
        self.defaults.removeObject(forKey: authKey)
        self.defaults.synchronize()
    }
    
    @discardableResult
    func loadToken() -> String? {
        self.accessToken = self.defaults.string(forKey: authKey)
        return self.accessToken
    }
    
    func saveChangeIdentifier(identifier: String) {
        self.apiChangeIdentifier = identifier
        self.defaults.set(apiChangeIdentifier, forKey: changeIdkey)
        self.defaults.synchronize()
    }
    
    @discardableResult
    func loadChangeIdentifier() -> String? {
        self.apiChangeIdentifier = self.defaults.string(forKey: changeIdkey)
        return self.apiChangeIdentifier
    }
    
    func isLoggedIn() -> Bool {
        guard loadToken() != nil else {
            return false
        }
        
        return true
    }
}
