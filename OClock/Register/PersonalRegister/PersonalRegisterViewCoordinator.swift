
//
//  PersonalRegisterViewCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit
import RxSwift

class PersonalRegisterViewCoordinator: CoordinatorProtocol {
   
    var navigationController: UINavigationController
    var isFirstRegister: Bool
    
    init(navigationController: UINavigationController, isFirstRegister: Bool = false) {
        self.navigationController = navigationController
        self.isFirstRegister = isFirstRegister
    }
    
    func start() {
        let service = PersonalRegisterViewService()
        let viewModel = PersonalRegisterViewModel(service: service, isFirstRegister: isFirstRegister)
        let v = PersonalRegisterView()
        let vc = PersonalRegisterViewController(viewModel: viewModel, baseView: v)
        
        //TODO weak self
        viewModel.navigationTarget
            .observe(on:  MainScheduler.instance)
            .subscribe(onNext: {  target in
                switch target {
                case .pop:
                    self.navigationController.popViewController(animated: true)
                case .nextView:
                    TimeDataRegisterViewCoordinator(navC: self.navigationController).start()
            }
        }).disposed(by: viewModel.myDisposeBag)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
extension PersonalRegisterViewCoordinator {
    enum Target {
        case pop
        case nextView
    }
}
