//
//  TextFieldTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/25/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

enum TextFieldTableViewCellType {
    case email
    case password
    case userType
    case storeName
    case ownerName
    
    case inputPacks
    case inputRewards
}

class TextFieldTableViewCell: UITableViewCell, NibLoadableView, ReusableView, CellConfigurable {

    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textFieldButton: UIButton!
    @IBOutlet weak var dropdownIcon: UIImageView!
    
    var viewModel: TextFieldCellViewModel?
    
    var isCellEnabled = true {
        didSet {
            isUserInteractionEnabled = isCellEnabled
            refresh()
        }
    }
    
    func setup(viewModel: RowViewModel) {
        if let textFieldCellViewModel = viewModel as? TextFieldCellViewModel {
            self.viewModel = textFieldCellViewModel
            textField.text = self.viewModel?.text.value
            textField.placeholder = self.viewModel?.placeholder ?? ""
            textField.keyboardType = self.viewModel?.keyboardType ?? .default
            textField.isSecureTextEntry = self.viewModel?.isSecure ?? false
            headerLabel.text = self.viewModel?.placeholder ?? ""
            isCellEnabled = self.viewModel?.enabled.value ?? false
            
            self.viewModel?.enabled.addObserver(fireNow: false, { (enabled) in
                self.isCellEnabled = enabled
            })
            
            textFieldButton.isHidden = !textFieldCellViewModel.isButtonType
            dropdownIcon.isHidden = !textFieldCellViewModel.isButtonType
                        
            textFieldCellViewModel.text.addObserver(fireNow: false) { (text) in
                self.textField.text = text
            }
            
            refresh()
        }
    }
    
    func refresh() {
        textField.alpha = isCellEnabled == true ? 1.0 : 0.50
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
    }
    
    fileprivate func setupTextField() {
        // Initialization code
        textField.isSecureTextEntry = false
        textField.keyboardType = .default
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: UIControl.Event.editingChanged)
        textField.addDoneButtonToKeyboard(myAction: #selector(textField.resignFirstResponder))
        
        textField.borderStyle = .none
        textField.backgroundColor = Constants.ColorTheme.systemGray6 // Use anycolor that give you a 2d look.

        //To apply corner radius
        textField.layer.cornerRadius = bounds.height / 2.0

        //To apply border
        textField.layer.borderWidth = 0.25
        textField.layer.borderColor = UIColor.white.cgColor

        //To apply Shadow
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 4.0
        textField.layer.shadowOffset = CGSize.zero // Use any CGSize
        textField.layer.shadowColor = UIColor.gray.cgColor

        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        viewModel?.buttonPressed?()
    }
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = (textField.text?.count ?? 0) + string.count
        let max = viewModel?.maxCharLimitCount ?? 0
        
        return max >= count
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        viewModel?.text.value = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
