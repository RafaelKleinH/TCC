//
//  HealthSecTableViewCell.swift
//  OClock
//
//  Created by Rafael Hartmann on 09/04/22.
//

import Foundation
import UIKit

class HealthSecTableViewCell: UITableViewCell {
    
    let tipImageView: UIImageView = {
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = RFKolors.modeSecondary.cgColor
        $0.layer.borderWidth = 2
        return $0
    }(UIImageView())
    
    let labelText: UILabel = {
        $0.font = UIFont(name: RFontsK.QuicksandMedium, size: RFKSize.medium)
        $0.textColor = RFKolors.modeSecondary
        $0.numberOfLines = 0
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    func setupSubview(haveImg: String?) {
        if haveImg != nil {
            addSubview(tipImageView)
        }
        addSubview(labelText)
    }
    
    func setupConstraints(haveImg: String?) {
        if haveImg != nil {
            tipImageView.anchor(top: topAnchor, paddingTop: RFKSize.medium)
            tipImageView.centerX(inView: self)
            tipImageView.setDimensions(height: 240, width: 240)
            
            labelText.anchor(top: tipImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft:  RFKSize.medium, paddingBottom:  RFKSize.medium, paddingRight:  RFKSize.medium)
        } else {
            labelText.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft:  RFKSize.medium, paddingBottom:  RFKSize.medium, paddingRight:  RFKSize.medium)
        }
    }
    
    func configure(with value: HealthSec) {
        self.backgroundColor = .clear
        setupSubview(haveImg: value.imageName)
        setupConstraints(haveImg: value.imageName)
        
        if let imgName = value.imageName {
            tipImageView.image = UIImage(named: imgName)
        }
        labelText.text = value.text
    }
}
