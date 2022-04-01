//
//  InitView.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView


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
        stack.spacing = RFKSize.mhigh
        return stack
    }()
    
    let iconImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "clockWithName")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
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
    
    let activityIndicator = RFKIndicatorView()
    
    let secondaryStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = RFKSize.medium
        return $0
    }(UIStackView())
    
    let thirdStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = RFKSize.medium
        return $0
    }(UIStackView())
    
    let userDefaultLabel: UILabel = {
        $0.textColor = RFKolors.whiteTexts
        $0.font = UIFont(name: RFontsK.QuicksandMedium, size: 16)
        return $0
    }(UILabel())
    
    let userDefaultSwith: UISwitch = {
        $0.isOn = false
        $0.preferredStyle = .sliding
        $0.onTintColor = RFKolors.secondaryBlue
        return $0
    }(UISwitch())
    
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
        contentView.addSubview(thirdStack)
        thirdStack.addArrangedSubview(userDefaultLabel)
        thirdStack.addArrangedSubview(userDefaultSwith)
        contentView.addSubview(secondaryStack)
        secondaryStack.addArrangedSubview(loginButton)
        secondaryStack.addArrangedSubview(dividerView)
        secondaryStack.addArrangedSubview(appleLogin)
        contentView.addSubview(registerButton)
        
        addSubview(activityIndicator)
    }
    
    private func installConstraints(){
        activityIndicator.isHidden = true

        contentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        iconImageView.centerX(inView: self)
        iconImageView.setDimensions(height: RFKSize.xxxhigh, width: RFKSize.xxxhigh)
        iconImageView.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, paddingTop: RFKSize.small)
        
        stack.anchor(top: iconImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.xxsmall, paddingLeft: RFKSize.high, paddingRight: RFKSize.high)
        
        emailTextField.setHeight(height: RFKSize.xhigh)
        
        passwordTextField.setHeight(height: RFKSize.xhigh)
        
        thirdStack.anchor(top: stack.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.high, paddingRight: RFKSize.high)
        
        secondaryStack.anchor(top: thirdStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.high, paddingBottom: RFKSize.high, paddingRight: RFKSize.high)
        
        loginButton.setHeight(height: RFKSize.xhigh)
       
        appleLogin.setHeight(height: RFKSize.high)
        
        registerButton.anchor(left: leftAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: rightAnchor, paddingLeft: RFKSize.medium, paddingBottom: RFKSize.small, paddingRight: RFKSize.medium)
        registerButton.setHeight(height: RFKSize.xhigh)
        
        activityIndicator.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, bottom: layoutMarginsGuide.bottomAnchor, right: rightAnchor)
    }
    
    func returnAlert(isSuccess: Bool, vc: UIViewController) {
        let alert = UIAlertController(title: isSuccess ? "alertSuccessTitle".localized() : "alertErrorTitle".localized(), message: isSuccess ? "alertSuccessMessage".localized() : "alertErrorMessage".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alertDismissAction".localized(), style: .default, handler: { _ in
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
}
