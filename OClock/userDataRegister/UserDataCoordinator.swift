//
//  UserDataRegisterCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/01/22.
//

import Foundation
import UIKit

class UserDataCoordinator: CoordinatorProtocol {
    
    let navigationController: UINavigationController
    
    init(navC: UINavigationController) {
        navigationController = navC
    }
    
    func start() {
        let v = UserDataView()
        let vm = UserDataViewModel()
        let vc = UserDataViewController(v: v, vm: vm)
        
        navigationController.pushViewController(vc, animated: true)
        
    }
}

extension UserDataCoordinator {
    enum Target {
        case nextView
    }
}
