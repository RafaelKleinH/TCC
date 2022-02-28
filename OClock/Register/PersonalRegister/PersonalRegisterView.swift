
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
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.whiteTexts
        return $0
    }(UIView())
    
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
        nameTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
        
        occupationTextField.styleTextField()
        occupationTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
   
        registerButton.addPrimaryStyle()
    }
    
    func setupSubviews() {
        addSubview(UIView(frame: .zero))
        addSubview(scrollView)
        addSubview(separatorNav)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(imageExplicationLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(occupationTextField)
        contentView.addSubview(registerButton)
    }

    func setupConstraints() {
        
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: separatorNav.bottomAnchor, bottom: bottomAnchor)
     
        contentView.centerX(inView: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.anchor(top: scrollView.layoutMarginsGuide.topAnchor, bottom: scrollView.layoutMarginsGuide.bottomAnchor)
        
        
        imageView.anchor(top: contentView.topAnchor, paddingTop: RFKSize.small)
        imageView.centerX(inView: self)
        imageView.setDimensions(height: 120, width: 120)
        
        imageExplicationLabel.anchor(top: imageView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.small, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium)
        
        nameTextField.anchor(top: imageExplicationLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.high, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: RFKSize.xhigh)
        occupationTextField.anchor(top: nameTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.high, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
    
        registerButton.anchor(top: occupationTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop:  RFKSize.xhigh, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
    }
    
}

