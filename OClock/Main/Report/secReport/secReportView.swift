//
//  secReportView.swift
//  OClock
//
//  Created by Rafael Hartmann on 19/03/22.
//

import Foundation
import UIKit

class SecReportView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RFKolors.bgColor
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentView = UIView()
    let scrollView = UIScrollView()
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.modeSecondary
        return $0
    }(UIView())
    
    let totalHoursSuport: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandRegular, size: 21)
        return $0
    }(UILabel())
    
    let totalHoursLabel: UILabel = {
        $0.textColor = RFKolors.modeSecondary
        $0.font = UIFont(name: RFontsK.QuicksandSemiBold, size: 21)
        return $0
    }(UILabel())
    
    let totalHoursStack: UIStackView = {
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    let tableView: UITableView = {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 82
        $0.backgroundColor = .clear
        $0.register(SecReportTableViewCell.self, forCellReuseIdentifier: SecReportTableViewCell.description())
        return $0
    }(UITableView())
    
    private func setupSubviews() {
        addSubview(UIView(frame: .zero))
        addSubview(separatorNav)
        addSubview(totalHoursStack)
        totalHoursStack.addArrangedSubview(totalHoursSuport)
        totalHoursStack.addArrangedSubview(totalHoursLabel)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        totalHoursStack.anchor(top: separatorNav.bottomAnchor, left:  leftAnchor, right: rightAnchor, paddingTop: RFKSize.small, paddingLeft: RFKSize.medium, paddingRight: RFKSize.medium)
    
        tableView.anchor(top: totalHoursStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: RFKSize.xsmall)
    }
}


