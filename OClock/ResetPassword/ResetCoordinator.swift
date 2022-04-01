//
//  ResetAq.swift
//  OClock
//
//  Created by Rafael Hartmann on 25/03/22.
//

import Foundation
import UIKit

class ResetCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navC: UINavigationController) {
        navigationController = navC
    }
    
    func start() {
        let view = ResetView()
        let viewModel = ResetViewModel()
        let viewController = ResetViewController(vm: viewModel, v: view)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
