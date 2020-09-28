//
//  PriceProgramAutoComputeTextFieldTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SDWebImage

class PriceProgramAutoComputeTextFieldTableViewCell: UITableViewCell, CellConfigurable, NibLoadableView, ReusableView {
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var checkIconImageView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var checkBoxContainerImageView: UIImageView!
    var viewModel: PsspAutoComputeCellViewModel?
    
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var cartonDisplayTextLabe: UILabel!
    
    func setup(viewModel: RowViewModel) {
        if let textFieldCellViewModel = viewModel as? PsspAutoComputeCellViewModel {
            self.viewModel = textFieldCellViewModel
            inputTextField.text = self.viewModel?.text.value
              
            underlineView.isHidden = textFieldCellViewModel.isUnderlineViewHidden
            percentageLabel.isHidden = textFieldCellViewModel.isPercentageLabelHiddden
            displayLabel.text = self.viewModel?.label
            displayImageView.isHidden =  textFieldCellViewModel.isDisplayImageViewHidden
            displayImageView.isHidden = true
            
            percentageLabel.text = textFieldCellViewModel.percentageLabel
            percentageLabel.isHidden = true
            
            checkBoxContainerImageView.isHidden = textFieldCellViewModel.isCircleImageHidden
            checkIconImageView.isHidden = textFieldCellViewModel.isCheckImageHidden
            
            checkButton.isEnabled = textFieldCellViewModel.isCheckButtonEnabled.value
            
           // displayImageView.sd_setImage(with: URL(string: textFieldCellViewModel.imageUrlString ?? ""), completed: nil)
            
            if let data = textFieldCellViewModel.imageData {
                displayImageView.image = UIImage(data: data)
            }
            inputTextField.isUserInteractionEnabled = textFieldCellViewModel.isTextFieldInteractionEnabled
            
            textField.isUserInteractionEnabled = false
            textField.backgroundColor = textFieldCellViewModel.isTextFieldInteractionEnabled ? UIColor.white : Constants.ColorTheme.primaryYellow
            
            cartonDisplayTextLabe.textColor = UIColor.black
        
            self.viewModel?.text.addObserver(fireNow: false, { (text) in
                self.inputTextField.text = text
            })
            
            self.viewModel?.subText.addObserver(fireNow: false, { (text) in
                self.secondTextField.text = text
            })
            
            self.viewModel?.isInputDisplayed.addObserver(fireNow: false) { (isDisplayed) in
                self.checkIconImageView.isHidden = textFieldCellViewModel.isCheckImageHidden
            }
            
            self.viewModel?.isCheckButtonEnabled.addObserver(fireNow: false) { (isDisplayed) in
                self.checkButton.isEnabled = textFieldCellViewModel.isCheckButtonEnabled.value
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextField()
        setupInputTextField()
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
        textField.layer.shadowOpacity = 1
        textField.layer.shadowRadius = 4.0
        textField.layer.shadowOffset = CGSize.zero // Use any CGSize
        textField.layer.shadowColor = UIColor.gray.cgColor
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    fileprivate func setupInputTextField() {
        // Initialization code
        
        inputTextField.isSecureTextEntry = false
        inputTextField.keyboardType = .numberPad
        inputTextField.delegate = self
        //inputTextField.clearButtonMode = .whileEditing
        inputTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: UIControl.Event.editingChanged)
        inputTextField.addDoneButtonToKeyboard(myAction: #selector(textField.resignFirstResponder))
        inputTextField.inputAssistantItem.leadingBarButtonGroups = []
        inputTextField.inputAssistantItem.trailingBarButtonGroups = []
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: inputTextField.frame.height))
        inputTextField.leftView = paddingView
        inputTextField.leftViewMode = UITextField.ViewMode.always
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
        secondTextField.layer.borderWidth = 4.0
        secondTextField.layer.borderColor = Constants.ColorTheme.primaryYellow.cgColor
        
        //To apply Shadow
        secondTextField.layer.shadowOpacity = 1
        secondTextField.layer.shadowRadius = 4.0
        secondTextField.layer.shadowOffset = CGSize.zero // Use any CGSize
        secondTextField.layer.shadowColor = UIColor.gray.cgColor
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: secondTextField.frame.height))
        secondTextField.leftView = paddingView
        secondTextField.leftViewMode = UITextField.ViewMode.always
    }
    
    func isSpecialCharacterForDecimalNumber(string: String) -> Bool {
        let validString = CharacterSet(charactersIn: "0123456789.")
        
        if string.rangeOfCharacter(from: validString.inverted) == nil
        {
            return false
        }
        
        if string == "" {
            return false
        }
        
        return true
    }
    
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        viewModel?.isInputDisplayed.value = !(viewModel?.isInputDisplayed.value ?? false)
    }
}

extension PriceProgramAutoComputeTextFieldTableViewCell: UITextFieldDelegate {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        
//        if textField == self.textField {
//            viewModel?.text.value = textField.text ?? ""
//        }
        
        if textField == self.secondTextField {
            viewModel?.subText.value = textField.text ?? ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString = string
        
        guard let textFieldText = textField.text else {
            return false
        }
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        if textFieldText.contains(".") == true{
            let newText = oldText.replacingCharacters(in: r, with: string)
            let numberOfDots = newText.components(separatedBy: ".").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.index(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            
            if numberOfDots > 1 || numberOfDecimalDigits > 1 {
                return false
            }
        }
        
        if isSpecialCharacterForDecimalNumber(string: newString) == true {
            return false
        }
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            newString = updatedText.replacingOccurrences(of: ",", with: "")
            
            print("New string: \(newString)")
         
            let newValue = Double(newString) ?? 0.0
            
            if newValue > 100000 {
                return false
            }
            
            print("New value: \(newValue)")
            
            var formattedNumber = formatNumberInput(newValue) ?? ""
            
            if string == "." {
                return false
                
            }
            
            textField.text = formattedNumber
            
            viewModel?.text.value = formattedNumber
            
            print("Show text return false: \(textField.text ?? "")")
        
            return false
        }
        
         print("Show text return true: \(textField.text ?? "")")
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func formatNumberInput(_ number: Double) -> String? {

       let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
       formatter.minimumFractionDigits = 0 // minimum number of fraction digits on right
       formatter.maximumFractionDigits = 1 // maximum number of fraction digits on right, or comment for all available
       formatter.minimumIntegerDigits = 0 // minimum number of integer digits on left (necessary so that 0.5 don't return .500)

       let formattedNumber = formatter.string(from: NSNumber.init(value: number))

       return formattedNumber

    }
    
}
