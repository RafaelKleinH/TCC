//
//  PreRegisterCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 23/02/22.
//

import Foundation
import UIKit
import RxSwift

class PreRegisterCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navC: UINavigationController) {
        navigationController = navC
    }
    
    func start() {
        let v =  PreRegisterView()
        let vm = PreRegisterViewModel()
        let vc = PreRegisterViewController(vm: vm, v: v)
        
        vm.navigationTarget
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {  target in
                switch target {
                case .nextView:
                    PersonalRegisterViewCoordinator(navigationController: self.navigationController, isFirstRegister: true).start()
                }
            })
            .disposed(by: vm.myDisposeBag)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
}

extension PreRegisterCoordinator {
    enum Target {
        case nextView
    }
}
