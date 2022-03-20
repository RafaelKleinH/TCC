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
        let timerCentral = TimerCentral()
        
        let homeViewModel = HomeViewModel(timerCentral: timerCentral)
        let homeBaseView = HomeView()
        let homeViewController = HomeViewController(vm: homeViewModel, v: homeBaseView)
        let homeTabBarItem = UITabBarItem(title: "Home", image: UIImage.add, tag: 0)
        homeViewController.tabBarItem = homeTabBarItem
        
        let reportViewModel = ReportViewModel(navC: navigationController)
        let reportBaseView = ReportView()
        let reportViewController = ReportViewController(v: reportBaseView, vm: reportViewModel)
        let reportTabBarItem = UITabBarItem(title: "Report", image: UIImage.checkmark, tag: 1)
        reportViewController.tabBarItem = reportTabBarItem
        
        let healthViewModel = HealthViewModel(timerCentral: timerCentral)
        let healthView = HealthView()
        let healthViewController = HealthViewController(v: healthView, vm: healthViewModel)
        let healthTabBarItem = UITabBarItem(title: "Health", image: UIImage.remove, tag: 2)
        healthViewController.tabBarItem = healthTabBarItem
        
        let configViewModel = ConfigViewModel(timerCentral: timerCentral)
        let configCoordinator = ConfigCoordinator(navC: navigationController, vm: configViewModel)
        configCoordinator.start()
        let configView = ConfigView()
        let configViewController = ConfigViewController(v: configView, vm: configViewModel)

        let configTabBarItem = UITabBarItem(title: "Config", image: UIImage.actions, tag: 3)
        configViewController.tabBarItem = configTabBarItem
        
        let tabBarController = MainTabBarController(HomeVC: homeViewController, ReportVC: reportViewController, HealthVC: healthViewController, ConfigVC: configViewController)
        
        homeViewModel.navigationTarget
            .subscribe(onNext: { target in
                guard let nav = homeViewController.navigationController else { return }
                switch target {
                case .registerBaseData:
                    PreRegisterCoordinator(navC: nav).start()
                case let .personalRegister(userData: user):
                    PersonalRegisterViewCoordinator(navigationController: nav, personalData: user).start()
                }
            }).disposed(by: homeViewModel.myDisposeBag)
        
        configViewModel.navigationTarget
            .subscribe(onNext: { [weak navigationController] target in
                guard let nav = tabBarController.navigationController else { return }
                switch target {
                case .logoff:
                    navigationController?.popViewController(animated: true)
                case .registerHours:
                    TimeDataRegisterViewCoordinator(navC: nav).start()
                }
            }).disposed(by: configViewModel.myDisposeBag)
        
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
        case personalRegister(userData: PersonalData)
    }
}
