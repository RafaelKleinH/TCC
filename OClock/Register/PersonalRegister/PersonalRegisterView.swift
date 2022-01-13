////
////  PersonalRegisterView.swift
////  OClock
////
////  Created by Rafael Hartmann on 08/01/22.
////
//
//import Foundation
//import UIKit
//
//class PersonalRegisterView: UIView {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        imagePicker.allowsEditing = true
//        imagePicker.mediaTypes = ["public.image"]
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    let imageView = RFKitRoundedImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    
//    let imagePicker = UIImagePickerController()
//    
//    let imageExplicationLabel = UILabel()
//    
//    func setupViewBasics() {
//        imageExplicationLabel.textAlignment = .center
//        imageExplicationLabel.font = UIFont(name: RFontsK.QuicksandLight, size: 12)
//        imageExplicationLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
//        
//        imageView.image = UIImage(named: CustomImages.defaultImageCircle)
//    }
//    
//    func setupSubviews() {
//        addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(imageExplicationLabel)
//        imageExplicationLabel.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    func setupConstraints() {
//        imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        imageView.centerXAnchor.constraint(equalTo:  centerXAnchor).isActive = true
//        
//        imageExplicationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12).isActive = true
//        imageExplicationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
//        imageExplicationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
//    }
//    
//}
