//
//  RFKitRoundedImageView.swift
//  OClock
//
//  Created by Rafael Hartmann on 04/01/22.
//

import Foundation
import UIKit

class RFKitRoundedImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = RFKolors.whiteTexts.cgColor
    }
}
