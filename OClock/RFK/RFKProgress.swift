//
//  RFKProgress.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/01/22.
//

import Foundation
import UIKit
import KDCircularProgress

class RFKProgress: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 0.00001)
        setupSubviews()
        setupAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let uselessCircularProgress: KDCircularProgress = {
        $0.startAngle = -235
        $0.progressThickness = 0.2
        $0.trackThickness = 0.2
        $0.glowMode = .reverse
        $0.glowAmount = 0
        $0.trackColor = .clear
        $0.roundedCorners = true
        $0.set(colors: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3))
        return $0
    }(KDCircularProgress())
    
    let circularProgress: KDCircularProgress = {
        $0.startAngle = -235
        $0.progressThickness = 0.2
        $0.trackThickness = 0.2
        $0.glowMode = .forward
        $0.glowAmount = 0
        $0.trackColor = .clear
        $0.roundedCorners = true
        $0.progressColors = [RFKolors.primaryBlue]
        return $0
    }(KDCircularProgress())
    
    func setupSubviews() {
        addSubview(uselessCircularProgress)
        addSubview(circularProgress)
    }
    
    func setupAnchors() {
        circularProgress.centerX(inView: self)
        circularProgress.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        uselessCircularProgress.centerX(inView: self)
        uselessCircularProgress.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    func attColors()  {
        circularProgress.progressColors = [RFKolors.primaryBlue]
    }
    
    func startProgress(angle: Double, time: TimeInterval) {
        circularProgress.progress = 0
        circularProgress.animate(toAngle: angle, duration: time, completion: nil)
    }
    
    func resumeProgress() {
        let layer = circularProgress.layer
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func pauseProgress() {
        let layer = circularProgress.layer
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func setupProgress(startAngle: Double = -235, animateToAngle: Double = 290) {
        uselessCircularProgress.startAngle = startAngle
        uselessCircularProgress.animate(toAngle: animateToAngle, duration: 0, completion: nil)
    }

    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
}
