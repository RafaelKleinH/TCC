//
//  secReportTableViewCell.swift
//  OClock
//
//  Created by Rafael Hartmann on 20/03/22.
//

import Foundation
import UIKit

class SecReportTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupContraints()
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let subStack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 12
        return $0
    }(UIStackView())
    
    let firstSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let initialDay: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let initialDayHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.text = "Dia de inicio:"
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        return $0
    }(UILabel())
    
    
    
    let secondSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let initialWeekDay: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let initialWeekDayHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        $0.text = "Dia na semana:"
        return $0
    }(UILabel())
    
    let thirdSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let initHour: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let initHourHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        $0.text = "Hora de inicio:"
        return $0
    }(UILabel())
    
    let fourthSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let endDay: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let endDayHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        $0.text = "Dia de encerramento:"
        return $0
    }(UILabel())
    
    let fithSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let endWeekDay: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let endWeekDayHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        $0.text = "Dia na semana:"
        return $0
    }(UILabel())
    
    let sixthSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let endHour: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let endHourHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        $0.text = "Hora do encerramento:"
        return $0
    }(UILabel())
    
    let seventhSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let intervalHours: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let intervalHoursHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        $0.text = "Total de intervalo:"
        return $0
    }(UILabel())
    
    let eighthSubStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let totalHours: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())

    let totalHoursHelper: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        $0.text = "Total de horas:"
        return $0
    }(UILabel())
    
    private func addSubviews() {
        addSubview(subStack)
        subStack.addArrangedSubview(firstSubStack)
        firstSubStack.addArrangedSubview(initialDayHelper)
        firstSubStack.addArrangedSubview(initialDay)
        
        subStack.addArrangedSubview(secondSubStack)
        secondSubStack.addArrangedSubview(initialWeekDayHelper)
        secondSubStack.addArrangedSubview(initialWeekDay)
        
        subStack.addArrangedSubview(thirdSubStack)
        thirdSubStack.addArrangedSubview(initHourHelper)
        thirdSubStack.addArrangedSubview(initHour)
        
        subStack.addArrangedSubview(fourthSubStack)
        fourthSubStack.addArrangedSubview(endDayHelper)
        fourthSubStack.addArrangedSubview(endDay)
        
        subStack.addArrangedSubview(fithSubStack)
        fithSubStack.addArrangedSubview(endWeekDayHelper)
        fithSubStack.addArrangedSubview(endWeekDay)
        
        subStack.addArrangedSubview(sixthSubStack)
        sixthSubStack.addArrangedSubview(endHourHelper)
        sixthSubStack.addArrangedSubview(endHour)
        
        subStack.addArrangedSubview(seventhSubStack)
        seventhSubStack.addArrangedSubview(intervalHoursHelper)
        seventhSubStack.addArrangedSubview(intervalHours)
        
        subStack.addArrangedSubview(eighthSubStack)
        eighthSubStack.addArrangedSubview(totalHoursHelper)
        eighthSubStack.addArrangedSubview(totalHours)
    }
    
    private func setupContraints() {
        subStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: RFKSize.xsmall, paddingLeft:  RFKSize.medium, paddingBottom:  RFKSize.xsmall, paddingRight:  RFKSize.medium)
    }
}
