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
        backgroundColor = UIColor(white: 0.2, alpha: 1)
        setupSubview()
        setupAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentView: UIView = {
        $0.backgroundColor = UIColor.white
        return $0
    }(UIView())
    
    let circularProgress: RFKProgress = {
        return $0
    }(RFKProgress())
    
    func setupSubview() {
        addSubview(contentView)
        contentView.addSubview(circularProgress)
    }
    
    func setupAnchors() {
        contentView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        circularProgress.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
    }
}
