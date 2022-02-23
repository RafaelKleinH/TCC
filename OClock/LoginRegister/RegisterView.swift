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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // let scrollView = UIScrollView()
    var scrollBottomConstraint: NSLayoutConstraint?
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.whiteTexts
        return $0
    }(UIView())
    
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
        emailTextField.placeholderColor = RFKolors.whiteTexts
        
        passwordTextField.styleTextField()
        passwordTextField.placeholderColor = RFKolors.whiteTexts
        passwordTextField.setTrailingImageView(isHidden: false, image: UIImage(named: CustomImages.securityEnterDisabled) ?? .strokedCheckmark)
        passwordTextField.isSecureTextEntry = true
      
        confirmPasswordTextField.styleTextField()
        confirmPasswordTextField.placeholderColor = RFKolors.whiteTexts
        confirmPasswordTextField.setTrailingImageView(isHidden: false, image: UIImage(named: CustomImages.securityEnterDisabled) ?? .strokedCheckmark)
        confirmPasswordTextField.isSecureTextEntry = true
        
   
        registerButton.addPrimaryStyle()
       
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(separatorNav)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(registerButton)
       
    }
    
    private func installConstraints() {
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: layoutMarginsGuide.topAnchor, bottom: layoutMarginsGuide.bottomAnchor)
     
        contentView.centerX(inView: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
        
        separatorNav.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 1)
        
        emailTextField.anchor(top: separatorNav.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.high, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: RFKSize.xhigh)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.high, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
        
        confirmPasswordTextField.anchor(top: passwordTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop:  RFKSize.high, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
        
        registerButton.anchor(top: confirmPasswordTextField.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop:  RFKSize.xhigh, paddingLeft:  RFKSize.medium, paddingBottom: RFKSize.xsmall, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
    }
}
