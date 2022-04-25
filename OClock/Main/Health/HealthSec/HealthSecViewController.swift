//
//  HealthSecViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 01/04/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HealthSecViewController: UIViewController, UIScrollViewDelegate {
    
    var baseView: HealthSecView
    var viewModel: HealthSecViewModelProtocol

    init(vm: HealthSecViewModelProtocol, v: HealthSecView) {
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
        rxBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        title = viewModel.navBarTitle
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.modeSecondary, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: RFKSize.medium) ?? UIFont.systemFont(ofSize: RFKSize.medium)]
        super.viewWillAppear(animated)
    }
    
    private func rxBind() {
        
        viewModel.data
            .bind(to: baseView.tableView.rx.items(cellIdentifier: HealthSecTableViewCell.description(), cellType: HealthSecTableViewCell.self)) { index, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: viewModel.disposeBag)
        
        
    }
}
