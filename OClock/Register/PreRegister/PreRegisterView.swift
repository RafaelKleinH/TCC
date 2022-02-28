//
//  PreRegisterView.swift
//  OClock
//
//  Created by Rafael Hartmann on 23/02/22.
//

import Foundation
import UIKit

class PreRegisterView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        confirmButton.addPrimaryStyle()
        setupSubviews()
        setupAnchors()
    }
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.whiteTexts
        return $0
    }(UIView())
    
    let textLabel: UILabel = {
        $0.textColor = RFKolors.whiteTexts
        $0.textAlignment = .left
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: RFKSize.medium)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())
    
    let confirmButton = RFKButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(UIView(frame: .zero))
        addSubview(scrollView)
        addSubview(separatorNav)
        scrollView.addSubview(contentView)
        contentView.addSubview(textLabel)
        contentView.addSubview(confirmButton)
    }
    
    func setupAnchors() {
        
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: separatorNav.bottomAnchor, bottom: bottomAnchor)
     
        contentView.centerX(inView: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.layoutMarginsGuide.bottomAnchor)
        
        textLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.small, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium)
        
        confirmButton.anchor(top: textLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.xhigh, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: 52)
        
        
    }
}
