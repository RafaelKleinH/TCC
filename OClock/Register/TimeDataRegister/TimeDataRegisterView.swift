//
//  TimeDataRegisterView.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit

class TimeDataRegisterView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        totalPauseHoursView.alpha = 0
        totalPauseHoursView.isHidden = true
        setupSubviews()
        setupAnchor()
        setupViewBasics()
    }
    
    //totalDeHoras
    //SeTemPause
    //SeSim Horas de Pausa
    //Horario de inicio
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
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
    
    let initialHour = RFKTextField()
    
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
        
        totalHoursTF.placeholderColor = RFKolors.whiteTexts
        totalPauseHoursTF.placeholderColor = RFKolors.whiteTexts
        initialHour.placeholderColor = RFKolors.whiteTexts
        
    }
    
    func setupSubviews() {
        addSubview(UIView(frame: .zero))
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(separatorNav)
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
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: topAnchor, bottom: bottomAnchor)
     
        contentView.centerX(inView: self)
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
        
        separatorNav.anchor(top: contentView.layoutMarginsGuide.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 1)
        
        totalHoursTF.anchor(top: separatorNav.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 36, paddingLeft: 24, paddingRight: 24, height: 52)
        
        mainPauseStack.anchor(top: totalHoursTF.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
        //TODO deixar essa caceta reta
        pauseStack.setHeight(height: 52)
    
        
        totalPauseHoursView.anchor(top: pauseStack.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24, height: 52)
        
        totalPauseHoursTF.anchor(top: totalPauseHoursView.topAnchor, left: totalPauseHoursView.leftAnchor, bottom: totalPauseHoursView.bottomAnchor, right: totalPauseHoursView.rightAnchor, height: 52)
        
        initialHour.anchor(top: mainPauseStack.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 32, paddingLeft: 24, paddingRight: 24, height: 52)
        

        confirmButton.anchor(top: initialHour.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 16, paddingRight: 24, height: 52)
    }
}
