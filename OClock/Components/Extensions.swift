//
//  Extensions.swift
//  OnboardingTutorial
//
//  Created by Stephen Dowless on 3/18/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor, let padding = paddingTop {
            self.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superviewTopAnchor = superview?.topAnchor,
            let superviewBottomAnchor = superview?.bottomAnchor,
            let superviewLeadingAnchor = superview?.leftAnchor,
            let superviewTrailingAnchor = superview?.rightAnchor else { return }
        
        anchor(top: superviewTopAnchor, left: superviewLeadingAnchor,
               bottom: superviewBottomAnchor, right: superviewTrailingAnchor)
    }
}

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func configureGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
    

extension UIViewController {
    func styleNavBar(navTitle: String?) {
        tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        if navTitle != nil {
            navigationController?.navigationBar.topItem?.title = navTitle
        }
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.modeSecondary, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: RFKSize.medium) ?? UIFont.systemFont(ofSize: RFKSize.medium)]
    }
}

extension Int {
    func toSec() -> String {
        let base = "\(self / 3600):\((self % 3600) / 60):\((self % 3600) % 60)"
        let arrays = base.components(separatedBy: ":")
        var correctArray: [String] = []
        for b in arrays {
            correctArray.append(b.count != 1 ? b : "0\(b)")
        }
        return "\(correctArray[0]):\(correctArray[1]):\(correctArray[2])"
    }
}

extension String {
    func weekDay() -> String {
        if self == "1" {
            return "WeekExtensionSun".localized()
        } else if self == "2" {
            return "WeekExtensionMon".localized()
        } else if self == "3" {
            return "WeekExtensionTue".localized()
        } else if self == "4" {
            return "WeekExtensionWed".localized()
        } else if self == "5" {
            return "WeekExtensionThur".localized()
        } else if self == "6" {
            return "WeekExtensionFri".localized()
        } else if self == "7" {
            return "WeekExtensionSat".localized()
        } else {
            return ""
        }
    }
}

extension UIView {
    public func removeAllConstraints() {
        for constraint in self.constraints {
                  
            if let first = constraint.firstItem as? UIView, first == self {
                self.removeConstraint(constraint)
            }
                  
            if let second = constraint.secondItem as? UIView, second == self {
                //self.removeConstraint(constraint)
            }
        }
          
        //self.removeConstraints(self.constraints)
      }
}
