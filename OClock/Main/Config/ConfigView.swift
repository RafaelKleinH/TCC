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
    
    let clockLabel: UILabel = {
        
        return $0
    }(UILabel())
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubview() {
        addSubview(clockLabel)
    }
    
    func setupConstraints() {
        clockLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 18, paddingLeft: 12, paddingRight: 12)
    }
}
