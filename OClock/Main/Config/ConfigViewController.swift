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
        tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.title = "CONFIGURAÇÕES"
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: RFKolors.modeSecondary, NSAttributedString.Key.font: UIFont(name: RFontsK.QuicksandBold, size: 24) ?? UIFont.systemFont(ofSize: 24)]
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
        
        viewModel.notifiesRegister
            .bind(to: baseView.notifiesDataBtn.rx.title())
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.hourRegister
            .bind(to: baseView.registerDataBtn.rx.title())
            .disposed(by: viewModel.myDisposeBag)
    }
}
