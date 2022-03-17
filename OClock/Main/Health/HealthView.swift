//
//  HealthView.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/03/22.
//

import Foundation
import UIKit


class HealthView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RFKolors.bgColor
        setupSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.modeSecondary
        return $0
    }(UIView())
    
    let scrollView: UIScrollView = UIScrollView()
    
    let contentView: UIView = UIView()
    
    let explicationLabel: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandMedium, size: RFKSize.medium)
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = RFKolors.modeSecondary
        $0.text = "   Assistencia de saúde é uma funcionalidade que visa lhe ajudar com algumas boas praticas durante o periodo de trabalho, fazendo assim com que a sua jornada de trabalho seja um pouco melhor, e a longo praso tenha um grande ganho em saúde. "
        return $0
    }(UILabel())
    
    let separatorText: UIView = {
        $0.backgroundColor = RFKolors.modeSecondary
        return $0
    }(UIView())
    
    let switchLabel: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandBold, size: RFKSize.medium)
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = RFKolors.modeSecondary
        $0.text = "Deseja ativar?"
        return $0
    }(UILabel())
    
    let healthSwitch: UISwitch = {
        return $0
    }(UISwitch())
    
    
    
    func setupSubview() {
        addSubview(UIView(frame: .zero))
        addSubview(separatorNav)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(explicationLabel)
        contentView.addSubview(separatorText)
        contentView.addSubview(switchLabel)
        contentView.addSubview(healthSwitch)
    }
    
    func setupConstraints() {
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: separatorNav.bottomAnchor, bottom: bottomAnchor)

        contentView.centerX(inView: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
        
        explicationLabel.anchor(top: contentView.layoutMarginsGuide.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.xsmall, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium)

        separatorText.anchor(top: explicationLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.medium, height: 1)
        
        switchLabel.anchor(top: separatorText.bottomAnchor, left: contentView.leftAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium)
        
        healthSwitch.anchor(top: switchLabel.topAnchor, left: switchLabel.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: RFKSize.xsmall, paddingRight: RFKSize.medium)
    }
}
