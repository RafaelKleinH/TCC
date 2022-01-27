//
//  ConfigView.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import UIKit

class ConfigView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let logOffBtn: UIButton = {
        $0.backgroundColor = RFKolors.secondaryBlue
        $0.isUserInteractionEnabled = true
        return $0
    }(UIButton())
    
    func setupSubview() {
        addSubview(logOffBtn)
    }
    
    func setupConstraints() {
        logOffBtn.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 32, paddingRight: 16, height: 32)
        
    }
}
