//
//  ResetView.swift
//  OClock
//
//  Created by Rafael Hartmann on 25/03/22.
//

import Foundation
import UIKit

class ResetView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        installConstraints()
        setupViewBasics()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let activityIndicator = RFKIndicatorView()
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.whiteTexts
        return $0
    }(UIView())
    
    let emailTextField = RFKTextField()
    let confirmEmailTextField = RFKTextField()
    
    let registerButton = RFKButton()
    
    
    
    private func addSubviews() {
        addSubview(UIView(frame: .zero))
        addSubview(scrollView)
        addSubview(separatorNav)
        scrollView.addSubview(contentView)
        contentView.addSubview(emailTextField)
        contentView.addSubview(confirmEmailTextField)
        contentView.addSubview(registerButton)
        
        addSubview(activityIndicator)
    }
    
    private func setupViewBasics(){
        emailTextField.styleTextField()
        emailTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
        confirmEmailTextField.styleTextField()
        confirmEmailTextField.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
        registerButton.addPrimaryStyle()
        activityIndicator.isHidden = true
    }
    
    private func installConstraints() {
        
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: separatorNav.bottomAnchor, bottom: layoutMarginsGuide.bottomAnchor)
     
        contentView.centerX(inView: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
        
        
        emailTextField.anchor(top: separatorNav.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.high, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: RFKSize.xhigh)
        
        confirmEmailTextField.anchor(top: emailTextField.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.mhigh, paddingLeft:  RFKSize.medium, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
        
        registerButton.anchor(top: confirmEmailTextField.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop:  RFKSize.xhigh, paddingLeft:  RFKSize.medium, paddingBottom: RFKSize.xsmall, paddingRight:  RFKSize.medium, height:  RFKSize.xhigh)
        
        activityIndicator.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    func returnAlert(isSuccess: Bool, vc: UIViewController) {
        let alert = UIAlertController(title: isSuccess ? "alertSuccessTitle".localized() : "alertErrorTitle".localized(), message: isSuccess ? "alertSuccessMessage".localized() : "alertErrorMessage".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alertDismissAction".localized(), style: .default, handler: { _ in
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
}
