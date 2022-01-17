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
        
        uselessCircularProgress.animate(toAngle: 290, duration: 0, completion: nil)
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
        $0.set(colors: RFKolors.primaryBlue)
        return $0
    }(KDCircularProgress())
    
    func setupSubviews() {
        addSubview(uselessCircularProgress)
        addSubview(circularProgress)
    }
    
    func setupAnchors() {
        circularProgress.center = CGPoint(x: self.center.x, y: self.center.y)
        circularProgress.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        uselessCircularProgress.center = CGPoint(x: self.center.x, y: self.center.y)
        uselessCircularProgress.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
