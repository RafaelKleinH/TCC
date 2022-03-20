//
//  secReportViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 19/03/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SecReportViewController: UIViewController, UIScrollViewDelegate {
    
    var viewModel: SecReportViewModelProtocol
    var baseView: SecReportView
    
    init(v: SecReportView, vm: SecReportViewModel) {
        baseView = v
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
       
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.modeSecondary, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
        super.viewWillAppear(animated)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        rxBind()
        view = baseView
        baseView.tableView.rx.setDelegate(self).disposed(by: viewModel.disposebag)
    }
    
    func rxBind() {
        
        viewModel.report
            .bind(to: baseView.tableView.rx.items(cellIdentifier: SecReportTableViewCell.description(), cellType: SecReportTableViewCell.self)) { index, element, cell in
                cell.endDay.text = element.endDay
                cell.initHour.text = element.initialHours
                cell.initialWeekDay.text = element.initialWeekday.weekDay()
                cell.initialDay.text = element.initialDay
                cell.endHour.text = element.endHours
                cell.endWeekDay.text = element.endWeekday.weekDay()
                cell.intervalHours.text = element.intervalTotalHours.toSec()
                cell.totalHours.text = element.totalHours.toSec()
            }
            .disposed(by: viewModel.disposebag)
        
        viewModel.month
            .map({ $0.uppercased() })
            .bind(to: rx.title)
            .disposed(by: viewModel.disposebag)
        
        viewModel.totalHours
            .bind(to: baseView.totalHoursLabel.rx.text)
            .disposed(by: viewModel.disposebag)
    }
    
  
}
