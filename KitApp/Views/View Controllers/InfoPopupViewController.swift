//
//  InfoPopupViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/28/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SDWebImage

class InfoPopupViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    
    var model: InfoImageEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = model?.caption
        //displayImageView.sd_setImage(with: URL(string: model?.image_url ?? ""), completed: nil)
        if let data = model?.image {
            displayImageView.image = UIImage(data: data)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPresseed(_ sender: UIButton) {
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
