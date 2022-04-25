//
//  HealthSecView.swift
//  OClock
//
//  Created by Rafael Hartmann on 01/04/22.
//

import Foundation
import UIKit

class HealthSecView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RFKolors.bgColor
        setupSubview()
        setupConstraints()
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
        $0.backgroundColor = .clear
        $0.allowsSelection = false
        $0.register(HealthSecTableViewCell.self, forCellReuseIdentifier: HealthSecTableViewCell.description())
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
