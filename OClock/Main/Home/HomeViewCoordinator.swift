//
//  HomeViewCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 05/01/22.
//

import Foundation
import UIKit
import RxSwift

class HomeViewCoordinator: CoordinatorProtocol {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = HomeViewModel()
        let baseView = HomeView()
        let viewController = HomeViewController(vm: viewModel, v: baseView)
        
        viewModel.navigationTarget
            .observe(on:  MainScheduler.instance)
            .subscribe(onNext: { [navigationController] target in
                switch target {
                case .register:
                    PersonalRegisterViewCoordinator(navigationController: navigationController).start()
                }
            }).disposed(by: viewModel.myDisposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
        }

}
extension HomeViewCoordinator {
    enum Target {
        case register
    }
}
