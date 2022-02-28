//
//  RFKIndicatorView.swift
//  OClock
//
//  Created by Rafael Hartmann on 27/02/22.
//

import Foundation
import NVActivityIndicatorView
import UIKit

class RFKIndicatorView: UIView {
    
    var activityIndicator = NVActivityIndicatorView(frame: .init(x: 0, y: 0, width: 0, height: 0), type: .ballBeat, color: .white, padding: 232)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
        setupAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        addSubview(activityIndicator)
    }
    
    func setupAnchors() {
        activityIndicator.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}
