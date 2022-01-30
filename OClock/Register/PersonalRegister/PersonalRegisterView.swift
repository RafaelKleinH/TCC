
//
//  PersonalRegisterView.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit

class PersonalRegisterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
        setupSubviews()
        setupConstraints()
        setupViewBasics()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let imageView = RFKitRoundedImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let imagePicker = UIImagePickerController()
    
    let imageExplicationLabel = UILabel()
    
    let nameTextField = RFKTextField()
    
    let occupationTextField = RFKTextField()
      
    let registerButton = RFKButton()
    
    func setupViewBasics() {
        imageExplicationLabel.textAlignment = .center
        imageExplicationLabel.font = UIFont(name: RFontsK.QuicksandLight, size: 12)
        imageExplicationLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        imageView.image = UIImage(named: CustomImages.defaultImageCircle)
        
        nameTextField.styleTextField()
        nameTextField.placeholderColor = RFKolors.whiteTexts
        
        occupationTextField.styleTextField()
        occupationTextField.placeholderColor = RFKolors.whiteTexts
   
        registerButton.addPrimaryStyle()
    }
    
    func setupSubviews() {
        addSubview(imageView)
        addSubview(imageExplicationLabel)
        addSubview(nameTextField)
        addSubview(occupationTextField)
        addSubview(registerButton)
    }

    func setupConstraints() {
        imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true

        imageView.anchor(top: layoutMarginsGuide.topAnchor, paddingTop: RFKSize.high)
        imageView.centerX(inView: self)
        imageView.setDimensions(height: 120, width: 120)
        
        imageExplicationLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.small, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium)
        
        nameTextField.anchor(top: imageExplicationLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: RFKSize.xhigh)
        occupationTextField.anchor(top: nameTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
    
        registerButton.anchor(top: occupationTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop:  RFKSize.high, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
    }
    
}

