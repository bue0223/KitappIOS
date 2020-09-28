//
//  UIManager.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/26/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SDWebImage

class UIManager {
    static let shared = UIManager()
    
    private init() {}
 
    func createController(fromStoryboard storyboard: String, withControllerId id: String) -> UIViewController? {
        let storyBoard = UIStoryboard(name: storyboard, bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: id)
    }

    func directToLogin() {
        if let vc = UIManager.shared.createController(fromStoryboard: "LoginRegistration", withControllerId: "LoginViewControllerID") {
            let mainWindow = (UIApplication.shared.delegate?.window)!
            mainWindow?.rootViewController = vc
        }
    }
    
    func directToMain() {
        if let vc = UIManager.shared.createController(fromStoryboard: "Main", withControllerId: "FilterRevealViewControllerID") {
            let mainWindow = (UIApplication.shared.delegate?.window)!
            mainWindow?.rootViewController = vc
        }
    }
}
