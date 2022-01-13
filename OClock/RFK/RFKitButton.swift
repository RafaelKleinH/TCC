//
//  RFKitButton.swift
//  OClock
//
//  Created by Rafael Hartmann on 14/11/21.
//

import Foundation
import UIKit

class RFKButton: UIButton {
    
    func addPrimaryStyle() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.8), for: .normal)
        layer.cornerRadius = 8
        titleLabel?.font = UIFont(name: RFontsK.QuicksandMedium, size: 20)
    }
    
    func addSecondaryStyle() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.8), for: .normal)
        layer.cornerRadius = 4
        titleLabel?.font = UIFont(name: RFontsK.QuicksandMedium, size: 20)
    }
}
