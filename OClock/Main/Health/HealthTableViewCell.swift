//
//  HealthTableViewCell.swift
//  OClock
//
//  Created by Rafael Hartmann on 01/04/22.
//


import Foundation
import UIKit


class HealthTableViewCell: UITableViewCell {
    
    let healthLabel: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.numberOfLines = 0
        $0.font = UIFont(name:RFontsK.QuicksandRegular, size: RFKSize.medium)
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(healthLabel)
    }
    
    private func setupConstraints() {
        healthLabel.centerY(inView: self)
        healthLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: RFKSize.medium, paddingLeft: RFKSize.medium, paddingBottom: RFKSize.medium, paddingRight: RFKSize.xsmall)
    }
    
     func configure(with title: String) {
         healthLabel.text = title
    }
}
