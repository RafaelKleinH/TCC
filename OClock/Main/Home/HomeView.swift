//
//  HomeView.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import UIKit
import KDCircularProgress

class HomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RFKolors.bgColor
        setupSubview()
        setupAnchors()
        
        firstSubProgress.titleLabel.text = "1 turno"
        secondSubProgress.titleLabel.text = "Almoço"
        thirdSubProgress.titleLabel.text = "2 turno"
        fourthSubProgress.titleLabel.text = "Hora Extra"
        
        firstSubProgress.progress.circularProgress.startAngle = 180
        secondSubProgress.progress.circularProgress.startAngle = 180
        thirdSubProgress.progress.circularProgress.startAngle = 180
        fourthSubProgress.progress.circularProgress.startAngle = 180
        
        circularProgress.uselessCircularProgress.progressColors = [RFKolors.progressMainBg]
            
        
        firstSubProgress.progress.setupProgress(startAngle: 180, animateToAngle: 360)
        secondSubProgress.progress.setupProgress(startAngle: 180, animateToAngle: 360)
        thirdSubProgress.progress.setupProgress(startAngle: 180, animateToAngle: 360)
        fourthSubProgress.progress.setupProgress(startAngle: 180, animateToAngle: 360)
        circularProgress.setupProgress(startAngle: -235, animateToAngle: 290)
        
        personalImageView.image = UIImage(named: "userCircle")?.withRenderingMode(.alwaysTemplate)
        personalImageView.tintColor = RFKolors.modeSecondary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    let contentView: UIView = {
        $0.backgroundColor = UIColor(named: "BgColor")
        return $0
    }(UIView())
    
    let horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .fill
        return $0
    }(UIStackView())
    
    let nameLabel: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandBold, size: RFKSize.medium)
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = RFKolors.modeSecondary
        return $0
    }(UILabel())
    
    let personalImageView = RFKitRoundedImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let circularProgress: RFKProgress = {
        return $0
    }(RFKProgress())
    
    let firstSubProgress = RFKMiniLoader()
    let secondSubProgress = RFKMiniLoader()
    let thirdSubProgress = RFKMiniLoader()
    let fourthSubProgress = RFKMiniLoader()
    
    let cronoImgView: UIImageView = {
        $0.image = UIImage(named: "apple")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = RFKolors.modeSecondary
        return $0
    }(UIImageView())
    
    let timeLabel: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandBold, size: RFKSize.medium)
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.text = "00:00:00"
        $0.textColor = RFKolors.modeSecondary
        return $0
    }(UILabel())
    
    let timeButton: UIButton = {
        $0.alpha = 1
        return $0
    }(UIButton())

    
    func setupSubview() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.addArrangedSubview(personalImageView)
        contentView.addSubview(circularProgress)
        contentView.addSubview(cronoImgView)
        contentView.addSubview(timeButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(firstSubProgress)
        contentView.addSubview(secondSubProgress)
        contentView.addSubview(thirdSubProgress)
        contentView.addSubview(fourthSubProgress)
    }
    
    func setupAnchors() {
        
        scrollView.centerX(inView: self)
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.anchor(top: topAnchor, bottom: bottomAnchor)
     
        contentView.centerX(inView: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.anchor(top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
       
        horizontalStackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium , paddingRight: RFKSize.medium)
        personalImageView.setDimensions(height: RFKSize.high, width: RFKSize.high)
        
        circularProgress.anchor(top: horizontalStackView.bottomAnchor, paddingTop: RFKSize.xsmall, width: RFKSize.bigger, height: RFKSize.bigger)
        circularProgress.centerX(inView: self)
        
        
        timeButton.anchor(top: circularProgress.circularProgress.topAnchor, left: circularProgress.circularProgress.leftAnchor, bottom: circularProgress.circularProgress.bottomAnchor, right: circularProgress.circularProgress.rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium, paddingBottom: RFKSize.medium, paddingRight: RFKSize.medium)
        
        timeLabel.centerX(inView: circularProgress.circularProgress)
        timeLabel.centerY(inView: circularProgress)
        
        cronoImgView.centerX(inView: circularProgress.circularProgress)
        cronoImgView.anchor(bottom: timeLabel.topAnchor, paddingBottom: RFKSize.xsmall, width: RFKSize.medium, height: RFKSize.medium)
        
        firstSubProgress.progress.setHeight(height: RFKSize.xxxhigh)
        secondSubProgress.progress.setHeight(height: RFKSize.xxxhigh)
        thirdSubProgress.progress.setHeight(height: RFKSize.xxxhigh)
        fourthSubProgress.progress.setHeight(height: RFKSize.xxxhigh)
        
        firstSubProgress.anchor(top: circularProgress.bottomAnchor, left: contentView.leftAnchor, right: contentView.centerXAnchor, paddingTop: RFKSize.xsmall, paddingLeft: RFKSize.xsmall, paddingRight: RFKSize.xxsmall)
        secondSubProgress.anchor(top: firstSubProgress.topAnchor, left: contentView.centerXAnchor, right: contentView.rightAnchor, paddingLeft: RFKSize.xxsmall, paddingRight: RFKSize.xsmall)
        thirdSubProgress.anchor(top: firstSubProgress.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.centerXAnchor, paddingTop: RFKSize.xsmall, paddingLeft: RFKSize.xsmall, paddingBottom: RFKSize.xsmall, paddingRight: RFKSize.xxsmall)
        fourthSubProgress.anchor(top: secondSubProgress.bottomAnchor, left: contentView.centerXAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: RFKSize.xsmall, paddingLeft: RFKSize.xxsmall, paddingBottom: RFKSize.xsmall, paddingRight: RFKSize.xsmall)
    }
}
