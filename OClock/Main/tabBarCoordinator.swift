//
//  tabBarCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import UIKit
import RxSwift

class MainTabBarCoordinator: CoordinatorProtocol {
    
    let navigationController: UINavigationController
    
    init(navC: UINavigationController) {
        navigationController = navC
    }
    
    func start() {
        let homeViewModel = HomeViewModel()
        let homeBaseView = HomeView()
        let homeViewController = HomeViewController(vm: homeViewModel, v: homeBaseView)
        let homeTabBarItem = UITabBarItem(title: "Home", image: UIImage.add, tag: 0)
        homeViewController.tabBarItem = homeTabBarItem
        
        homeViewModel.navigationTarget
            .subscribe(onNext: { [weak navigationController] target in
                switch target {
                case .registerBaseData:
                    PersonalRegisterViewCoordinator(navigationController: self.navigationController).start()
                }
            }).disposed(by: homeViewModel.myDisposeBag)
        
        
        let configViewModel = ConfigViewModel()
        let configCoordinator = ConfigCoordinator(navC: navigationController, vm: configViewModel)
        configCoordinator.start()
        let configView = ConfigView()
        let configViewController = ConfigViewController(v: configView, vm: configViewModel)
        
        configViewModel.navigationTarget
            .subscribe(onNext: { [weak navigationController] target in
                switch target {
                case .logoff:
                    navigationController?.popViewController(animated: true)
                case .registerHours:
                    TimeDataRegisterViewCoordinator(navC: self.navigationController).start()
                }
            }).disposed(by: configViewModel.myDisposeBag)

        
        let configTabBarItem = UITabBarItem(title: "Config", image: UIImage.actions, tag: 1)
        configViewController.tabBarItem = configTabBarItem
        
        
        
        let tabBarController = MainTabBarController(HomeVC: homeViewController, ConfigVC: configViewController)
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
}

extension MainTabBarCoordinator {
    enum TargetC {
        case logoff
        case registerHours
    }
    
    enum TargetH {
        case registerBaseData
    }
}
