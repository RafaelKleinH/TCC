
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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = PersonalRegisterViewService()
        let viewModel = PersonalRegisterViewModel(service: service)
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
