//
//  ViewControllerInterface.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/19/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import AVFoundation

protocol ViewControllerInterface {
    //var viewModel: ViewModelProtocol? { get set }
}

extension ViewControllerInterface where Self: UIViewController {
    func presentPopup(popupType: PopupType = .goToHomePage, okButtonHandler: @escaping (() -> Void)) {
        let popupController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        popupController.modalPresentationStyle = .overFullScreen
        popupController.okButtonPressed =  {
            popupController.dismiss(animated: true, completion: nil)
            okButtonHandler()
            
        }
        
        self.navigationController?.present(popupController, animated: true, completion: nil)
        popupController.loadView()
        popupController.type = popupType
    }
    
    func registerForKeyboardWillShowNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height - 64, right: scrollView.contentInset.right)

            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }

    func registerForKeyboardWillHideNotification(_ scrollView: UIScrollView, usingBlock block: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)

            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            block?(keyboardSize)
        })
    }
}

protocol AudioPlayerController: class {
    // { get set }
    
    var player: AVAudioPlayer? { get set }
}

extension AudioPlayerController where Self: UIViewController {
    func playAudioFile(resource: String) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            // For iOS 11
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            // For iOS versions < 11
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let aPlayer = player else { return }
            aPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension UIScrollView {

    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        self.contentInset = edgeInsets
        self.scrollIndicatorInsets = edgeInsets
    }
}
