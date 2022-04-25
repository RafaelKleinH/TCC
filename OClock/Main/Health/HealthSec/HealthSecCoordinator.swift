//
//  HealthSecCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 01/04/22.
//

import Foundation
import UIKit

class HealthSecCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    var selectedRow: Int
    
    init(navC: UINavigationController, selectedRow: Int) {
        self.navigationController = navC
        self.selectedRow = selectedRow
    }
    
    func start() {
        let view = HealthSecView()
        let viewModel = HealthSecViewModel(selectedRow: selectedRow)
        let controller = HealthSecViewController(vm: viewModel,v: view)
        
        navigationController.pushViewController(controller, animated: true)
    }
}
