//
//  ConfigView.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import UIKit

class ConfigView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RFKolors.bgColor
        
        setupSubview()
        setupConstraints()
        registerDataBtn.addTStyle(haveArrow: true)
        notifiesDataBtn.addTStyle(haveArrow: true)
        logOffBtn.addTStyle()
        
        registerDataBtn.contentHorizontalAlignment = .left
        notifiesDataBtn.contentHorizontalAlignment = .left
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentView: UIView = {
        return $0
    }(UIView())
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.modeSecondary
        return $0
    }(UIView())
    
    let registerDataBtn = RFKButton()
    
    let notifiesDataBtn = RFKButton()
    
    let logOffBtn = RFKButton()
    
    
    func setupSubview() {
        addSubview(contentView)
        contentView.addSubview(separatorNav)
        contentView.addSubview(registerDataBtn)
        contentView.addSubview(notifiesDataBtn)
        contentView.addSubview(logOffBtn)
    }
    
    func setupConstraints() {
        
        contentView.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 1)
        
        registerDataBtn.anchor(top: separatorNav.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24,  height: 52)
        notifiesDataBtn.anchor(top: registerDataBtn.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 52)
        logOffBtn.anchor(left: contentView.leftAnchor, bottom: contentView.layoutMarginsGuide.bottomAnchor, right: contentView.rightAnchor, paddingBottom: 0, height: 52)
        
        
    }
}
