//
//  RFKitTextFiel.swift
//  OClock
//
//  Created by Rafael Hartmann on 14/11/21.
//

import Foundation
import UIKit

class RFKTextField: UITextField {
    
    var _placeholder: String?
    var labelDisplayed = false
    var textWillHaveAImage: Bool = false
    var canDeleteLabel: Bool = true
    
    
    var trailingImageView: UIButton = {
        var imgV = UIButton()
        imgV.imageView?.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        return imgV
    }()
    
    var placeholderColor: UIColor = UIColor.systemGray {
        didSet {
            self.setPlaceholderColor()
        }
    }
    
    
    
    private func setPlaceholderColor() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor])
    }
    
    func styleTextField() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.05)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4).cgColor
        self.layer.cornerRadius = 4
        self.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelInit()
        placeholderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        addTarget(self, action: #selector(self.labelInit), for: .editingChanged)
        addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingChanged)
        _placeholder = (_placeholder != nil) ? _placeholder : placeholder
        placeholder = _placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let floatinglabel: UILabel = {
        var label = UILabel()
        label.text = "text"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        label.font = UIFont(name: RFontsK.QuicksandMedium, size: 14)
        return label
    }()
    
    func setTrailingImageView(isHidden: Bool = true, image: UIImage) {
        trailingImageView.setImage(image, for: .normal)
        trailingImageView.isHidden = isHidden
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trailingImageView)
        trailingImageView.clipsToBounds = true
    
        trailingImageView.frame = CGRect(x: CGFloat(frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        trailingImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        trailingImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        bringSubviewToFront(trailingImageView)
    }
    
    @objc private func labelInit() {
        _placeholder == nil ? _placeholder = placeholder : nil
        if text != "" && labelDisplayed == false && canDeleteLabel{
            labelDisplayed = true
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.floatinglabel.text = self._placeholder
                self.floatinglabel.clipsToBounds = true
                self.floatinglabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 18)
                self.addSubview(self.floatinglabel)
                self.floatinglabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                self.floatinglabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            }
         
            
            self.placeholder = ""
        }
        self.setNeedsDisplay()
    }
    
    func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        canDeleteLabel = false
        if let existingText = text, isSecureTextEntry {
            deleteBackward()
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
        canDeleteLabel = true
    }
    
    @objc private func removeFloatingLabel() {
        if text == "" && canDeleteLabel {
            labelDisplayed = false
            UIView.animate(withDuration: 0.5) {
                self.floatinglabel.removeFromSuperview()
                self.placeholder = self._placeholder
                self.setNeedsDisplay()
            }
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let paddingText = textWillHaveAImage ? UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 40) : UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: paddingText)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let paddingText = textWillHaveAImage ? UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 40) : UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: paddingText)
    }
}


