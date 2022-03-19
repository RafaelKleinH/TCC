//
//  ReportView.swift
//  OClock
//
//  Created by Rafael Hartmann on 16/03/22.
//

import Foundation
import UIKit

class ReportView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RFKolors.bgColor
        setupSubview()
        setupConstraints()
        tableView.separatorStyle = .singleLine
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let separatorNav: UIView = {
        $0.backgroundColor = RFKolors.modeSecondary
        return $0
    }(UIView())
    
    
    let tableView: UITableView = {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 82
        $0.backgroundColor = .clear
        $0.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.description())
        return $0
    }(UITableView())
    
    func setupSubview() {
        addSubview(UIView(frame: .zero))
        addSubview(separatorNav)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        separatorNav.anchor(top: layoutMarginsGuide.topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        tableView.anchor(top: separatorNav.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
}
