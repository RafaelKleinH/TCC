//
//  ReportViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 16/03/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReportViewController: UIViewController {
    
    var baseView: ReportView
    var viewModel: ReportViewModel
    
    init(v: ReportView, vm: ReportViewModel) {
        baseView = v
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        baseView.tableView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
       
        rxFuncs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "RELATÓRIO"
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.modeSecondary, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
        super.viewWillAppear(animated)
        viewModel.viewDidLoad.onNext(())
    }
    
    private func rxFuncs() {
        
        viewModel.dataSource
            .bind(to: baseView.tableView.rx.items(cellIdentifier: ReportTableViewCell.description(), cellType: ReportTableViewCell.self)) { index, element, cell in
                cell.monthLabel.text = element
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.data
            .subscribe(onNext: { value in
                
            })
            .disposed(by: viewModel.disposeBag)
        
        baseView.tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.index.onNext(indexPath.row)
                self?.viewModel.didTap.onNext(indexPath.row)
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.subs
            .subscribe()
            .disposed(by: viewModel.disposeBag)
    }
}

extension ReportViewController: UITableViewDelegate {}
