//
//  DividerView.swift
//  OClock
//
//  Created by Rafael Hartmann on 09/01/22.
//

import Foundation
import UIKit

class RKDividerView: UIView {
    
    let label: UILabel = {
        var label = UILabel()
        label.text = "OR"
        label.textColor = RFKolors.whiteTexts
        label.font = UIFont(name: RFontsK.QuicksandBold, size: 14)
        return label
    }()
    
}
