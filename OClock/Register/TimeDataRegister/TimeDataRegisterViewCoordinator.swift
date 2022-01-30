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
        
        viewModel.navigationTarget
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { target in
            switch target {
            case .pop:
                print("pop")
            case .returnHome:
                print("returnHome")
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
