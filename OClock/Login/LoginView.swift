//
//  InitView.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import UIKit
import JGProgressHUD



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
    

    let contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        stack.isUserInteractionEnabled = true
        stack.spacing = RFKSize.medium
        return stack
    }()
    
    let iconImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    let emailTextField = RFKTextField()
    let passwordTextField: RFKTextField = {
        var tf = RFKTextField()
        tf.isUserInteractionEnabled = true
        tf.textWillHaveAImage = true
        return tf
    }()
    
    
    let loginButton = RFKButton()
    let registerButton: RFKButton = {
        var rb = RFKButton()
        return rb
    }()
    
    let appleLogin: RFKButton = {
        let button = RFKButton(type: .system)
        button.addSecondaryStyle()
        return button
    }()
    let appleImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    let activityIndicator: JGProgressHUD = {
        let ld = JGProgressHUD()
        return ld
    }()
    
    let secondaryStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = RFKSize.medium
        return $0
    }(UIStackView())
    
    let dividerView = RFKDividerView()
    
    private func setupViewBasics(){

        emailTextField.styleTextField()
        passwordTextField.styleTextField()
        passwordTextField.setTrailingImageView(isHidden: false, image: UIImage(named: CustomImages.securityEnterDisabled) ?? .strokedCheckmark)
        passwordTextField.isSecureTextEntry = true
      
        
        loginButton.addPrimaryStyle()
        registerButton.addSecondaryStyle()
       
    }
    
    private func addSubViews(){

        addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(stack)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(passwordTextField)
        contentView.addSubview(secondaryStack)
        secondaryStack.addArrangedSubview(loginButton)
        secondaryStack.addArrangedSubview(dividerView)
        secondaryStack.addArrangedSubview(appleLogin)
        contentView.addSubview(appleImage)
        contentView.addSubview(registerButton)
        
        addSubview(activityIndicator)

 
    }
    
    private func installConstraints(){
        

        contentView.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: rightAnchor)
        
        iconImageView.centerX(inView: self)
        iconImageView.setDimensions(height: RFKSize.xxhigh, width: RFKSize.xxhigh)
        iconImageView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, paddingTop: RFKSize.high)
        
        stack.anchor(top: iconImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.high, paddingLeft: RFKSize.high, paddingRight: RFKSize.high)
        secondaryStack.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.high, paddingBottom: RFKSize.high, paddingRight: RFKSize.high)
        
        emailTextField.setHeight(height: RFKSize.xhigh)
        
        passwordTextField.setHeight(height: RFKSize.xhigh)
        
        loginButton.setHeight(height: RFKSize.xhigh)
       
        appleLogin.setHeight(height: RFKSize.high)
        
        registerButton.anchor(left: leftAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: rightAnchor, paddingLeft: RFKSize.medium, paddingBottom: RFKSize.small, paddingRight: RFKSize.medium)
        registerButton.setHeight(height: RFKSize.xhigh)
        
        activityIndicator.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: rightAnchor)
        
        appleImage.centerY(inView: appleLogin)
        appleImage.anchor(right: appleLogin.titleLabel?.leftAnchor, paddingRight: RFKSize.small, width: RFKSize.medium, height: RFKSize.medium)
    }
}
