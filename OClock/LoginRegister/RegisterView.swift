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
    
    let contentView = UIView()
    
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
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(confirmPasswordTextField)
        addSubview(registerButton)
       
    }
    
    private func installConstraints() {
        emailTextField.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.xxhigh, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: RFKSize.xhigh)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
        confirmPasswordTextField.anchor(top: passwordTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop:  RFKSize.medium, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
        registerButton.anchor(top: confirmPasswordTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop:  RFKSize.high, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
    }
}
