//
//  ConfigCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import UIKit

class ConfigCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    var viewModel: ConfigViewModelProtocol
    
    init(navC: UINavigationController, vm: ConfigViewModelProtocol) {
        navigationController = navC
        viewModel = vm
    }
    
    func start() {}
}

extension ConfigCoordinator {
    enum Target {
        case logoff
    }
}
