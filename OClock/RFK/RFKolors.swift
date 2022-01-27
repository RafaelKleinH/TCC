//
//  RFKolors.swift
//  OClock
//
//  Created by Rafael Hartmann on 04/01/22.
//

import Foundation
import UIKit

struct RFKolors {
    static var whiteTexts = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    static var secondaryBlue = UIColor(named: "sColor") ??  UIColor(red: 0/255, green: 4/255, blue: 40/255, alpha: 1)
    static var primaryBlue =  UIColor(named: "pColor") ?? UIColor(red: 0/255, green: 78/255, blue: 146/255, alpha: 1)
    
    static var progressMainBg = UIColor(named: "circularProgressColor") ??  UIColor(red: 0/255, green: 4/255, blue: 40/255, alpha: 1)
    static var modeSecondary = UIColor(named: "SecColor") ??  UIColor(red: 0/255, green: 4/255, blue: 40/255, alpha: 1)
    
    
}
