//
//  HomeView.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import UIKit


class HomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.98, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
