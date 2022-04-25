//
//  TimeDataRegisterView.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit
import JGProgressHUD

class TimeDataRegisterView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        totalPauseHoursView.alpha = 0
        totalPauseHoursView.isHidden = true
        setupSubviews()
        setupAnchor()
        setupViewBasics()
        initialHour.inputView = initialHourPickerView
        totalHoursTF.inputView = totalHoursPickerView
        totalPauseHoursTF.inputView = totalPausePickerView
        setPicker()
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var activityIndicator = RFKIndicatorView()
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.whiteTexts
        return $0
    }(UIView())
    
    let totalHoursTF = RFKTextField()
    
    let totalHoursPickerView: UIPickerView = {
        
        return $0
    }(UIPickerView())
    
    let pauseStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    let pauseLabel: UILabel = {
        $0.textColor = RFKolors.whiteTexts
        $0.font = UIFont(name: RFontsK.QuicksandMedium, size:20)
        return $0
    }(UILabel())
    
    let pauseSwith = UISwitch()
 
    let mainPauseStack:  UIStackView = {
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .fill
        $0.clipsToBounds = true
        return $0
    }(UIStackView())
    
    let totalPauseHoursView = UIView()
    
    let totalPauseHoursTF = RFKTextField()
    
    let totalPausePickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
    let initialHour = RFKTextField()
    
    let initialHourPickerView: UIPickerView = {
        return $0
    }(UIPickerView())
    
    let confirmButton: RFKButton = {
        $0.addPrimaryStyle()
        return $0
    }(RFKButton())
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewBasics() {
        totalHoursTF.styleTextField()
        totalPauseHoursTF.styleTextField()
        initialHour.styleTextField()
        
        totalHoursTF.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
        totalPauseHoursTF.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
        initialHour.placeholderColor = RFKolors.whiteTexts.withAlphaComponent(0.6)
        
        
    }
    
    func setupSubviews() {
        addSubview(UIView(frame: .zero))
        addSubview(activityIndicator)
        addSubview(scrollView)
        addSubview(separatorNav)
        scrollView.addSubview(contentView)
        contentView.addSubview(totalHoursTF)
        contentView.addSubview(mainPauseStack)
        mainPauseStack.addArrangedSubview(pauseStack)
        pauseStack.addArrangedSubview(pauseLabel)
        pauseStack.addArrangedSubview(pauseSwith)
        mainPauseStack.addArrangedSubview(totalPauseHoursView)
        totalPauseHoursView.addSubview(totalPauseHoursTF)
        contentView.addSubview(initialHour)
        contentView.addSubview(confirmButton)
    }
    
    func setTotalPauseHoursTF(_ app: Bool) {
        totalPauseHoursView.setHeight(height: 52)
    }
    
    func setupAnchor() {
        activityIndicator.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: separatorNav.bottomAnchor, bottom: bottomAnchor)
     
        contentView.centerX(inView: self)
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
        
        
        
        totalHoursTF.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 36, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: RFKSize.xhigh)
        
        mainPauseStack.anchor(top: totalHoursTF.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium)
        
        pauseStack.setHeight(height: 52)
    
        pauseSwith.anchor(top: pauseLabel.topAnchor)
        
        totalPauseHoursView.anchor(top: pauseStack.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: 52)
        
        totalPauseHoursTF.anchor(top: totalPauseHoursView.topAnchor, left: totalPauseHoursView.leftAnchor, bottom: totalPauseHoursView.bottomAnchor, right: totalPauseHoursView.rightAnchor, height: RFKSize.xhigh)
    
        
        initialHour.anchor(top: mainPauseStack.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.high, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium, height: RFKSize.xhigh)
        

        confirmButton.anchor(top: initialHour.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium, paddingBottom: RFKSize.small, paddingRight: RFKSize.medium, height: 52)
    }
    
    func setPicker() {

    }
}
