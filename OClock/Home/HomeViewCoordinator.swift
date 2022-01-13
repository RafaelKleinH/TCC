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
        let v = HomeView()
        let vc = HomeViewController(vm: viewModel, v: v)

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
extension HomeViewCoordinator {
    enum Target {
        case pop
    }
}
