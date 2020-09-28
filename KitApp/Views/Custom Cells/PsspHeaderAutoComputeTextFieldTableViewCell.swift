//
//  PsspHeaderAutoComputeTextFieldTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class PsspHeaderAutoComputeTextFieldTableViewCell: UITableViewCell, CellConfigurable, NibLoadableView, ReusableView {
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var firstTextFieldDisplayLabel: UILabel!
    @IBOutlet weak var secondTextFieldDisplayLabel: UILabel!
    
    var viewModel: PsspHeaderAutoComputeTextFieldCellViewModel?
    
    func setup(viewModel: RowViewModel) {
        if let textFieldCellViewModel = viewModel as? PsspHeaderAutoComputeTextFieldCellViewModel {
            self.viewModel = textFieldCellViewModel
            firstTextFieldDisplayLabel.text = self.viewModel?.text.value
            displayLabel.text = textFieldCellViewModel.displayText
            self.viewModel?.text.addObserver(fireNow: false, { (text) in
                self.firstTextFieldDisplayLabel.text = text
                self.textField.placeholder = text.isEmpty ? "000,000" : ""
            })
            
            self.viewModel?.subText.addObserver(fireNow: false, { (text) in
                self.secondTextFieldDisplayLabel.text = text
                self.secondTextField.placeholder = text.isEmpty ? "00,000,000" : ""
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
        setupSecondTextField()
    }
    
    fileprivate func setupTextField() {
        // Initialization code
        
        textField.isSecureTextEntry = false
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: UIControl.Event.editingChanged)
        textField.addDoneButtonToKeyboard(myAction: #selector(textField.resignFirstResponder))
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
        
        textField.borderStyle = .none // Use anycolor that give you a 2d look.
        
        //To apply corner radius
        textField.layer.cornerRadius = 10.0
        
        //To apply border
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = Constants.ColorTheme.primaryYellow.cgColor
        
        //To apply Shadow

        
        textField.layer.shadowColor = UIColor.white.cgColor
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 5.0
        textField.layer.shadowOpacity = 1.0
        textField.layer.masksToBounds = false
        textField.layer.shouldRasterize = true
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    func setupSecondTextField() {
        
        secondTextField.isSecureTextEntry = false
        secondTextField.keyboardType = .numberPad
        secondTextField.delegate = self
        secondTextField.clearButtonMode = .whileEditing
        secondTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: UIControl.Event.editingChanged)
        secondTextField.addDoneButtonToKeyboard(myAction: #selector(secondTextField.resignFirstResponder))
        secondTextField.inputAssistantItem.leadingBarButtonGroups = []
        secondTextField.inputAssistantItem.trailingBarButtonGroups = []
        
        secondTextField.borderStyle = .none // Use anycolor that give you a 2d look.
        
        //To apply corner radius
        secondTextField.layer.cornerRadius = 10.0
        
        //To apply border
        secondTextField.layer.borderWidth = 2.0
        secondTextField.layer.borderColor = Constants.ColorTheme.primaryYellow.cgColor
        
        //To apply Shadow

        
        secondTextField.layer.shadowColor = UIColor.white.cgColor
         secondTextField.layer.shadowOffset = .zero
         secondTextField.layer.shadowRadius = 5.0
         secondTextField.layer.shadowOpacity = 1.0
         secondTextField.layer.masksToBounds = false
         secondTextField.layer.shouldRasterize = true
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: secondTextField.frame.height))
        secondTextField.leftView = paddingView
        secondTextField.leftViewMode = UITextField.ViewMode.always
    }
    
    func isSpecialCharacterForDecimalNumber(string: String) -> Bool {
        let validString = CharacterSet(charactersIn: "0123456789")
        
        if string.rangeOfCharacter(from: validString.inverted) == nil
        {
            return false
        }
        
        if string == "" {
            return false
        }
        
        return true
    }
}

extension PsspHeaderAutoComputeTextFieldTableViewCell: UITextFieldDelegate {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        
        if textField == self.textField {
            viewModel?.text.value = textField.text ?? ""
        }
        
        if textField == self.secondTextField {
            viewModel?.subText.value = textField.text ?? ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString = string
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            newString = updatedText
        }
        
        if isSpecialCharacterForDecimalNumber(string: newString) == true {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
