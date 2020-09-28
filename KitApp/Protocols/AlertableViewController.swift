//
//  AlertableViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/25/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

protocol AlertableController {}

extension AlertableController where Self: UIViewController {
    func alert(title: String = "", message: String, alertActions: [UIAlertAction] = []) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        prepareAlertActions(alertActions, alertController)
        present(alertController, animated: true, completion: nil)
    }
    
    func prepareAlertActions(_ alertActions: [UIAlertAction], _ alertController: UIAlertController) {
        if alertActions.isEmpty {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }else {
            for action in alertActions {
                alertController.addAction(action)
            }
        }
    }
}
