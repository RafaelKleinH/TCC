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

        }

}
extension HomeViewCoordinator {
    enum Target {
        case register
    }
}
