//
//  ReportViewCell.swift
//  OClock
//
//  Created by Rafael Hartmann on 19/03/22.
//

import Foundation
import UIKit


class ReportTableViewCell: UITableViewCell {
    
    let monthLabel: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name:RFontsK.QuicksandRegular, size: 32)
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
        addSubview(monthLabel)
    }
    
    private func setupConstraints() {
        monthLabel.centerY(inView: self)
        monthLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: RFKSize.xsmall, paddingLeft: RFKSize.medium, paddingBottom: RFKSize.xsmall, paddingRight: RFKSize.xsmall)
    }
    
     func configure(with month: String) {
        monthLabel.text = month
    }
}
