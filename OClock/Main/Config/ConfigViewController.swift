//
//  ConfigViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ConfigViewController: UIViewController {
    
    var viewModel: ConfigViewModelProtocol
    var baseView: ConfigView
    
    override func viewDidLoad() {
        view = baseView
        rxBinds()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        styleNavBar(navTitle: viewModel.navBarTitle)
        super.viewWillAppear(animated)
    }
    
    init(v: ConfigView, vm: ConfigViewModelProtocol) {
        viewModel = vm
        baseView = v
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rxBinds() {
        
        baseView.logOffBtn.rx.tap
            .bind(to: viewModel.didClickLogoff)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.logoffBack.subscribe().disposed(by: viewModel.myDisposeBag)
        
        baseView.registerDataBtn.rx.tap
            .bind(to: viewModel.didClickHoursRegister)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.logOffText
            .bind(to: baseView.logOffBtn.rx.title())
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.hourRegister
            .bind(to: baseView.registerDataBtn.rx.title())
            .disposed(by: viewModel.myDisposeBag)
    }
}
