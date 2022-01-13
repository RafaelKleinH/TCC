//
//  Gradient.swift
//  OClock
//
//  Created by Rafael Hartmann on 14/11/21.
//

import Foundation
import UIKit



extension UIView {
    
    public func addGradient(firstColor: UIColor, secondColor: UIColor){
        let gl = CAGradientLayer()
        
        let colorTop = firstColor
        let colorBottom = secondColor
        gl.frame = bounds
        gl.colors = [colorTop.cgColor, colorBottom.cgColor]
        gl.locations = [0.0, 1.0]
        gl.startPoint = CGPoint(x: 0, y: 0)
        gl.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        layer.insertSublayer(gl, at: 0)
    }
}

