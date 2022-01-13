//
//  DividerView.swift
//  OClock
//
//  Created by Rafael Hartmann on 09/01/22.
//

import Foundation
import UIKit

class RFKDividerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label: UILabel = {
            let label = UILabel()
            label.text = "DividerText".localized()
            label.textColor = RFKolors.whiteTexts
            label.font = UIFont(name: RFontsK.QuicksandBold, size: 14)
            return label
        }()
        
        addSubview(label)
        label.centerX(inView: self)
        label.centerY(inView: self)
        
        let firstDivider: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 1, alpha: 0.25)
            return view
        }()
        
        addSubview(firstDivider)
        firstDivider.centerY(inView: self)
        firstDivider.anchor(left: leftAnchor, right: label.leftAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
        
        let secondDivider: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 1, alpha: 0.25)
            return view
        }()
        
        addSubview(secondDivider)
        secondDivider.centerY(inView: self)
        secondDivider.anchor(left: label.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
