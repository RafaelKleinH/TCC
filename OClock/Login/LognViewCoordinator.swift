//
//  InitViewCoordinator.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import UIKit
import RxSwift

class LoginViewCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LoginViewModel()
        let baseView = LoginView()
        let viewController = LoginViewController(baseView: baseView, viewModel: viewModel)
        
        viewModel.navigationTarget
            .observe(on:  MainScheduler.instance)
            .subscribe(onNext: { [weak self] target in
                guard let self = self else { return }
                switch target {
                case .loginButton:
                    MainTabBarCoordinator(navC: self.navigationController).start()
                case .registerButton:
                    RegisterViewCoordinator(navigationController: self.navigationController).start()
                case .resetPassword:
                    ResetCoordinator(navC: self.navigationController).start()
                }
            }).disposed(by: viewModel.myDisposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension LoginViewCoordinator {
    enum Target {
        case loginButton
        case registerButton
        case resetPassword
    }
}
