//
//  HomeViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    var viewModel: HomeViewModel
    var baseView: HomeView
    
    init(vm: HomeViewModel, v: HomeView) {
        viewModel = vm
        baseView = v
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view = baseView
        rxBinds()
        viewModel.didViewLoad.onNext(())
       
    }
    
    override func viewWillLayoutSubviews() {
        baseView.circularProgress.circularProgress.animate(toAngle: 290, duration: 3, completion: nil)
    }
    
    func rxBinds() {
        viewModel.userData
            .subscribe(onNext: { [weak self] data in
                if data?.name == "" {
                    self?.viewModel.didGoToRegisterView.onNext(())
                }
            }, onError: { _ in
                print("HOME:erro")
            })
            .disposed(by: viewModel.myDisposeBag)
        
    }
}

