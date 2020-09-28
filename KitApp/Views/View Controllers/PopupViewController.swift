//
//  PopupViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/22/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

enum PopupType {
    case goToHomePage
    case needsUpdate
    case needsForceUpdateData
    case needsInternet
}

class PopupViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLabelConstraintSubTitle: NSLayoutConstraint!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    var type: PopupType = .goToHomePage {
        didSet {
            topLabelConstraintSubTitle.constant = 8.0
            iconImageView.isHidden = true
            
            if type == .needsInternet {
                topLabelConstraintSubTitle.constant = 8.0
                iconImageView.isHidden = true
                titleLabel.text = "Please connect to the Internet"
                subTitleLabel.text = "We recommend that you connect to the internet, so the app can download the latest content from our database."
                noButton.isHidden = true
                closeButton.isHidden = true
            }else if type == .needsUpdate {
                topLabelConstraintSubTitle.constant = 140.0
                iconImageView.isHidden = false
                okButton.setTitle("UPDATE NOW", for: .normal)
                noButton.setTitle("NO THANKS", for: .normal)
                noButton.backgroundColor = UIColor.clear
                noButton.setTitleColor(Constants.ColorTheme.primaryYellow, for: .normal)
                titleLabel.text = "New Update is available."
                subTitleLabel.text = "We recommend that you download the latest update of KITApp."
            }else if type == .needsForceUpdateData {
                topLabelConstraintSubTitle.constant = 140.0
                iconImageView.isHidden = false
                okButton.setTitle("UPDATE NOW", for: .normal)
                noButton.setTitle("NO THANKS", for: .normal)
                noButton.backgroundColor = UIColor.clear
                noButton.setTitleColor(Constants.ColorTheme.primaryYellow, for: .normal)
                titleLabel.text = "New Update is available."
                subTitleLabel.text = "We recommend that you download the latest update of KITApp."
                noButton.isHidden = true
                closeButton.isHidden = true
            }
            
        }
    }
    
    var okButtonPressed: (() -> Void)?
    var cancelButtonPressed: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        okButtonPressed?()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
