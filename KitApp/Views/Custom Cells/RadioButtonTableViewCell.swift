//
//  RadioButtonTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import DLRadioButton

class RadioButtonTableViewCell: UITableViewCell, NibLoadableView, ReusableView, CellConfigurable {
    
    @IBOutlet weak var firstButton: DLRadioButton!
    
    @IBOutlet weak var secondButton: DLRadioButton!
    
    var viewModel: RadioButtonTableViewCellViewModel?


    func setup(viewModel: RowViewModel) {
        if let viewModel = viewModel as? RadioButtonTableViewCellViewModel {
            self.viewModel = viewModel
            
            self.firstButton.isSelected = false
            self.secondButton.isSelected = false
            
            isCellEnabled = self.viewModel?.enabled.value ?? false
            
            self.viewModel?.enabled.addObserver(fireNow: false, { (enabled) in
                self.isCellEnabled = enabled
            })
            
            self.viewModel?.isAutoPickFirstItem.addObserver(fireNow: false, { (isAutoPick) in
                self.refreshForAutoPickFirstItem()
            })
        }
    }
    
    var isCellEnabled = true {
        didSet {
            if viewModel?.isAutoPickFirstItem.value == false {
                isUserInteractionEnabled = isCellEnabled
                refresh()
            }

        }
    }
    
    func refresh() {
        firstButton.alpha = isCellEnabled == true ? 1.0 : 0.50
        secondButton.alpha = isCellEnabled == true ? 1.0 : 0.50
    }
    
    
    func refreshForAutoPickFirstItem() {
        if viewModel?.isAutoPickFirstItem.value == true {
            firstButton.sendActions(for: UIControl.Event.touchUpInside)
            isUserInteractionEnabled = true
            firstButton.alpha = 1.0
            secondButton.alpha = 1.50
        }else {
            isUserInteractionEnabled = true
            firstButton.alpha = 1.0
            secondButton.alpha = 1.50
        }

    }
    
    @IBAction func firstButtonPressed(_ sender: DLRadioButton) {
        viewModel?.firstButtonPressed?()
    }
    
    
    @IBAction func secondButtonPressed(_ sender: DLRadioButton) {
        viewModel?.secondButtonPressed?()
    }
}
