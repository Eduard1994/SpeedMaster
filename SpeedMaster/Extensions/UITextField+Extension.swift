//
//  UITextField+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

// MARK: - UITextField
extension UITextField {
    func setPlaceholder(_ placeholder: String) {
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.lightGray])
    }
    
    // Clear buton
    func addClearButton() {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "closeOnboarding"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        
        rightView = button
        rightViewMode = .whileEditing
    }
    
    @objc func clear(_ sender: Any) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    
    // Attributed PlaceHolder
    func addAttributedPlaceHolder(placeholder: String, font: UIFont = UIFont.sfProText(ofSize: 16, style: .regular)) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.8), NSAttributedString.Key.font: font])
    }
    
    // Underlining
    func underlined() {
        let bottomLine = CALayer()
        let width = CGFloat(1.0)
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        bottomLine.backgroundColor = UIColor.white.cgColor
        bottomLine.borderWidth = width
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
        self.layer.masksToBounds = true
    }
    
    @IBInspectable var doneAccessory: Bool{
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneClearButtonOnKeyboard()
            }
        }
    }
    
    // Done Button
    func addDoneClearButtonOnKeyboard(clearButtonColor: UIColor = .mainYellow, doneButtonColor: UIColor = .mainBlue) {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        
        let clear: UIBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(self.clearButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [clear, flexSpace, done]
        clear.tintColor = clearButtonColor
        done.tintColor = doneButtonColor
        
        toolBar.items = items
        toolBar.sizeToFit()
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.endEditing(true)
    }
    
    @objc func clearButtonAction() {
        self.text = nil
    }
}

// MARK: - Properties
extension UITextField {
    
    public typealias TextFieldConfig = (UITextField) -> Swift.Void
    
    public func config(textField configurate: TextFieldConfig?) {
        configurate?(self)
    }
    
    func left(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
    
    func right(image: UIImage?, color: UIColor = .black) {
        if let image = image {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
}

// MARK: - Methods
public extension UITextField {
    
    /// Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    /// Set placeholder text and its color
    func placeholder(text value: String, color: UIColor = .red) {
        self.attributedPlaceholder = NSAttributedString(string: value, attributes: [ NSAttributedString.Key.foregroundColor : color])
    }
}


