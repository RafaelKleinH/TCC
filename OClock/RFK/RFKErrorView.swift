//
//  RFKErrorView.swift
//  OClock
//
//  Created by Rafael Hartmann on 27/02/22.
//

import Foundation
import UIKit

class RFKErrorView: UIView {
    
    var errorLabel: UILabel = {
        
        return $0
    }(UILabel())
    
    var errorButton: RFKButton = {
        $0.addSecondaryStyle()
        return $0
    }(RFKButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(errorLabel)
        addSubview(errorButton)
    }
    
    func setupAnchors() {
        errorLabel.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 12, paddingRight: 12)
        errorButton.anchor(top: errorLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 12, paddingRight: 12)
    }
    
}
