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
        $0.textColor = RFKolors.whiteTexts
        $0.textAlignment = .center
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        $0.text =
        
"""
Ops, Ocorreu um erro.
  Tente novamente.
"""
        
        return $0
    }(UILabel())
    
    var errorButton: RFKButton = {
        $0.addSecondaryStyle()
        $0.setTitle("Recarregar", for: .normal)
        return $0
    }(RFKButton())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(errorLabel)
        addSubview(errorButton)
    }
    
    func setupAnchors() {
        errorLabel.anchor(top: layoutMarginsGuide.centerYAnchor, left: leftAnchor, right: rightAnchor, paddingTop: -32, paddingLeft: RFKSize.small, paddingRight: RFKSize.small)
        errorButton.anchor(top: errorLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: RFKSize.xsmall, paddingLeft: RFKSize.small, paddingRight: RFKSize.small, height: RFKSize.xhigh)
    }
    
}
