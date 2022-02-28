//
//  TimeDataRegisterViewCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit
import RxSwift

class TimeDataRegisterViewCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navC: UINavigationController) {
        navigationController = navC
    }
    
    func start() {
        let view = TimeDataRegisterView()
        let viewModel: TimeDataRegisterViewModelProtocol = TimeDataRegisterViewModel()
        let viewController = TimeDataRegisterViewController(vm: viewModel, bv: view)
        
        //TODO weak
        viewModel.navigationTarget
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak navigationController] target in
            switch target {
            case .pop:
                navigationController?.popViewController(animated: true)
            case .returnHome:
                for _ in 0...3 {
                    navigationController?.popViewController(animated: true)
                }
            }
        }).disposed(by: viewModel.disposeBag)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension TimeDataRegisterViewCoordinator {
    enum Target {
        case pop
        case returnHome
    }
}
