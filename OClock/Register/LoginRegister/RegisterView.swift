//
//  RegisterView.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/11/21.
//

import Foundation
import UIKit

class RegisterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupViewBasics()
        installConstraints()
        
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let scrollView = UIScrollView()
    var scrollBottomConstraint: NSLayoutConstraint?
    
    let contentView = UIView()
    
    let imageView = RFKitRoundedImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let imagePicker = UIImagePickerController()
    
    let imageExplicationLabel = UILabel()
    
    let emailTextField = RFKTextField()
    
    let passwordTextField: RFKTextField = {
        var tf = RFKTextField()
        tf.textWillHaveAImage = true
        return tf
    }()
    
    let confirmPasswordTextField: RFKTextField = {
        var tf = RFKTextField()
        tf.textWillHaveAImage = true
        return tf
    }()
    
    
    let registerButton = RFKButton()
    
    private func setupViewBasics(){
        emailTextField.styleTextField()
        emailTextField.placeholderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        
        passwordTextField.styleTextField()
        passwordTextField.placeholderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        passwordTextField.setTrailingImageView(isHidden: false, image: UIImage(named: CustomImages.securityEnterDisabled) ?? .strokedCheckmark)
        passwordTextField.isSecureTextEntry = true
      
        confirmPasswordTextField.styleTextField()
        confirmPasswordTextField.placeholderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        confirmPasswordTextField.setTrailingImageView(isHidden: false, image: UIImage(named: CustomImages.securityEnterDisabled) ?? .strokedCheckmark)
        confirmPasswordTextField.isSecureTextEntry = true
        
        imageExplicationLabel.textAlignment = .center
        imageExplicationLabel.font = UIFont(name: RFontsK.QuicksandLight, size: 12)
        imageExplicationLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        registerButton.addPrimaryStyle()
        
        imageView.image = UIImage(named: CustomImages.defaultImageCircle)
       
    }
    
   
    
   
    
    private func addSubviews() {
      
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageExplicationLabel)
        imageExplicationLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(confirmPasswordTextField)
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func installConstraints() {
        
//        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.centerXAnchor.constraint(equalTo:  centerXAnchor).isActive = true

        
        imageExplicationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12).isActive = true
        imageExplicationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        imageExplicationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        
        emailTextField.topAnchor.constraint(equalTo: imageExplicationLabel.bottomAnchor, constant: 24).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true

        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true

        
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24).isActive = true
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        confirmPasswordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true

        
        registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
       
    }
}
