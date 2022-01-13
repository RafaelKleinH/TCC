//
//  RegisterViewCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/11/21.
//

import Foundation
import UIKit
import RxSwift

class RegisterViewCoordinator: CoordinatorProtocol {
   
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = RegisterViewService()
        let viewModel = RegisterViewModel(service: service)
        let v = RegisterView()
        let vc = RegisterViewController(viewModel: viewModel, baseView: v)
        
        viewModel.navigationTarget
            .observe(on:  MainScheduler.instance)
            .subscribe(onNext: { [weak self] target in
                guard let self = self else { return }
                switch target {
                case .pop:
                    self.navigationController.popViewController(animated: true)
            }
        }).disposed(by: viewModel.myDisposeBag)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
extension RegisterViewCoordinator {
    enum Target {
        case pop
    }
}
