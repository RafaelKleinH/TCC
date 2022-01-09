//
//  InitView.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setupViewBasics()
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    let contentView: UIView = {
//        var view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let scrollView: UIScrollView = {
//        var scroll = UIScrollView()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.showsVerticalScrollIndicator = false
//        scroll.showsHorizontalScrollIndicator = false
//        return scroll
//    }()
    
    let stack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    let iconImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = .checkmark
        return iv
    }()
    
    let emailTextField = RFKTextField()
    let passwordTextField: RFKTextField = {
        var tf = RFKTextField()
        tf.textWillHaveAImage = true
        return tf
    }()
    
    
    let loginButton = RFKButton()
    let registerButton: RFKButton = {
        var rb = RFKButton()
        return rb
    }()
    
    
    private func setupViewBasics(){
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        emailTextField.styleTextField()
        passwordTextField.styleTextField()
        passwordTextField.setTrailingImageView(isHidden: false, image: UIImage(named: CustomImages.securityEnterDisabled) ?? .strokedCheckmark)
        passwordTextField.isSecureTextEntry = true
      
        
        loginButton.addPrimaryStyle()
        registerButton.addSecondaryStyle()
       
    }
    
    private func addSubViews(){
        //addSubview(scrollView)
        //addSubview(contentView)
        addSubview(iconImageView)
        addSubview(stack)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(loginButton)
        addSubview(registerButton)
 
    }
    
    private func installConstraints(){
        
//        scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        iconImageView.centerX(inView: self)
        iconImageView.setDimensions(height: 120, width: 120)
        iconImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        stack.anchor(top: iconImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        emailTextField.setHeight(height: 50)
        passwordTextField.setHeight(height: 50)
        

        registerButton.anchor(left: leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: trailingAnchor, paddingLeft: 24, paddingBottom: 16, paddingRight: 24)
        
    }
    
    
}
