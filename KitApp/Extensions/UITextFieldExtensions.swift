//
//  UITextFieldExtensions.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/25/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

extension UITextField {
    func addDoneButtonToKeyboard(myAction: Selector?) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    func keepTextFieldAboveKeyboard(tableView: UITableView, view: UIView? = nil) {
        
        var willShowNotification: NSObjectProtocol?
        var willHideNotification: NSObjectProtocol?
        
        willShowNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) {(notification) in
            
            let userInfo = notification.userInfo!
            
            if let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                if view == nil && UIDevice.current.userInterfaceIdiom != .pad {
                    // Get my height size
                    let myheight = tableView.frame.height
                    // Get the top Y point where the keyboard will finish on the view
                    let keyboardEndPoint = myheight - keyboardFrame.height
                    // Get the the bottom Y point of the textInput and transform it to the currentView coordinates.
                    if let pointInTable = self.superview?.convert(self.frame.origin, to: tableView) {
                        
                        let textFieldBottomPoint = pointInTable.y + self.frame.size.height + 100
                        
                        // Finally check if the keyboard will cover the textInput
                        if keyboardEndPoint <= textFieldBottomPoint {
                            tableView.contentOffset.y = textFieldBottomPoint - keyboardEndPoint
                        }
                    }
                } else {
                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                        if view?.frame.origin.y == 0 {
                            view?.frame.origin.y -= keyboardSize.height
                        }
                    }
                }
            }
            
            NotificationCenter.default.removeObserver(willShowNotification!)
        }
        
        willHideNotification = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) { (_) in
            
            if view?.frame.origin.y != 0 {
                view?.frame.origin.y = 0
            }
            
            NotificationCenter.default.removeObserver(willHideNotification!)
        }
    }
}
