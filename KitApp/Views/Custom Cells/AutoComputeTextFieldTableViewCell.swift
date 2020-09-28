//
//  AutoComputeTextFieldTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class AutoComputeTextFieldTableViewCell: UITableViewCell, NibLoadableView, ReusableView, CellConfigurable {

    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    
    var viewModel: AutoComputeTextFieldCellViewModel?
    
    func setup(viewModel: RowViewModel) {
        if let textFieldCellViewModel = viewModel as? AutoComputeTextFieldCellViewModel {
            self.viewModel = textFieldCellViewModel
            textField.text = self.viewModel?.text.value
            textField.placeholder = self.viewModel?.placeholder ?? ""
            textField.keyboardType = self.viewModel?.keyboardType ?? .default
            textField.isSecureTextEntry = self.viewModel?.isSecure ?? false
            
            secondTextField.isHidden = self.viewModel?.isSubFieldHidden ?? true
            secondTextField.isUserInteractionEnabled = self.viewModel?.isSubFieldUserInteractionEnabled ?? false
            
            displayLabel.text = self.viewModel?.placeholder ?? ""
            displayLabel.isHidden = self.viewModel?.isDisplayLabelHidden ?? true
            
            if let data = self.viewModel?.imageData {
                displayImageView.image = UIImage(data: data)
            }
            
            self.viewModel?.subText.addObserver(fireNow: false, { (text) in
                self.secondTextField.text = text
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
        
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.white // Use anycolor that give you a 2d look.

        //To apply corner radius
        textField.layer.cornerRadius = 5.0

        //To apply border
        textField.layer.borderWidth = 0.25
        textField.layer.borderColor = UIColor.white.cgColor

        //To apply Shadow
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 2.0
        textField.layer.shadowOffset = CGSize.zero // Use any CGSize
        textField.layer.shadowColor = UIColor.gray.cgColor

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
        secondTextField.addDoneButtonToKeyboard(myAction: #selector(textField.resignFirstResponder))
        secondTextField.inputAssistantItem.leadingBarButtonGroups = []
        secondTextField.inputAssistantItem.trailingBarButtonGroups = []
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

extension AutoComputeTextFieldTableViewCell: UITextFieldDelegate {
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
