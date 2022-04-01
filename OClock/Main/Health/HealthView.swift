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
    
    let pauseStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    let explanationStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    let mainPauseStack:  UIStackView = {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .fill
        $0.clipsToBounds = true
        return $0
    }(UIStackView())
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.modeSecondary
        return $0
    }(UIView())
    
    let arrowImageView: UIImageView = {
        $0.image = UIImage(named: "topArrow")
        return $0
    }(UIImageView())

    let scrollView: UIScrollView = UIScrollView()
    
    let contentView: UIView = UIView()
    
    let explicationOpen: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandBold, size: RFKSize.medium)
        $0.numberOfLines = 0
        $0.textColor = RFKolors.modeSecondary
        $0.text = "healthWantToKnow".localized()
        return $0
    }(UILabel())
    
    let explicationLabel: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandMedium, size: RFKSize.small)
        $0.numberOfLines = 0
        $0.textColor = RFKolors.modeSecondary
        $0.text = "healthViewExplanation".localized()
        return $0
    }(UILabel())
    
    let switchLabel: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandBold, size: RFKSize.medium)
        $0.textColor = RFKolors.modeSecondary
        $0.text = "healthViewActivateText".localized()
        return $0
    }(UILabel())
    
    let tableView: UITableView = {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 82
        $0.backgroundColor = .clear
        $0.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.description())
        return $0
    }(UITableView())
    
    let healthSwitch: UISwitch = {
        return $0
    }(UISwitch())
    
    let explanationaView = UIView()
    
    func setupSubview() {
        addSubview(UIView(frame: .zero))
        addSubview(separatorNav)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainPauseStack)
        mainPauseStack.addArrangedSubview(pauseStack)
        mainPauseStack.addArrangedSubview(explanationStack)
        pauseStack.addArrangedSubview(switchLabel)
        pauseStack.addArrangedSubview(healthSwitch)
        explanationStack.addArrangedSubview(explicationOpen)
        mainPauseStack.addArrangedSubview(explanationaView)
        explanationaView.addSubview(explicationLabel)
        contentView.addSubview(tableView)
    
    }
    
    func setupConstraints() {
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: separatorNav.bottomAnchor, bottom: bottomAnchor)

        contentView.centerX(inView: self)
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
        
        
        
        mainPauseStack.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium)
       
     //   pauseStack.setHeight(height: 52)
        
        healthSwitch.anchor(top: switchLabel.topAnchor)
        
        explanationaView.anchor(top: explicationOpen.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        explicationLabel.anchor(top: explanationaView.topAnchor, left: explanationaView.leftAnchor, bottom: explanationaView.bottomAnchor, right: explanationaView.rightAnchor)
        
        tableView.anchor(top: mainPauseStack.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
    }
}
