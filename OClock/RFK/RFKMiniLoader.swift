//
//  RFKMiniLoader.swift
//  OClock
//
//  Created by Rafael Hartmann on 20/01/22.
//

import Foundation
import UIKit
import KDCircularProgress

class RFKMiniLoader: UIView {
    
    let titleLabel: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandBold, size: 18)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    let progress = RFKProgress()
    
    let progressLabel: UILabel = {
        $0.textColor = RFKolors.primaryBlue
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
        
        let blurEffect = UIBlurEffect(style: .light)
        let vibr = UIVibrancyEffect(blurEffect: blurEffect)
        let blurView = UIVisualEffectView(effect: vibr)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        insertSubview(blurView, at: 0)
        
        backgroundColor = UIColor(named: "SecColor")?.withAlphaComponent(0.050)
        setupSubviews()
        setupAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(progress)
        addSubview(progressLabel)
    }
    
    func updateColor() {
        titleLabel.textColor = RFKolors.modeSecondary
        progress.attColors()
    }
    
    func setupAnchors() {
        titleLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        progress.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 12, paddingRight: 8)
        progressLabel.anchor(top: progress.circularProgress.topAnchor, left: progress.circularProgress.leftAnchor, bottom: progress.circularProgress.bottomAnchor, right: progress.circularProgress.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
    }
}


import RxCocoa
import RxSwift

public extension Reactive where Base: KDCircularProgress {
   var progress: Binder<Double> { progress }
}
