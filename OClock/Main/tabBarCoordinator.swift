//
//  tabBarCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import UIKit

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
        
        
        
        let configViewModel = ConfigViewModel()
        let configView = ConfigView()
        let configViewController = ConfigViewController(v: configView, vm: configViewModel)
        let configTabBarItem = UITabBarItem(title: "Config", image: UIImage.actions, tag: 1)
        configViewController.tabBarItem = configTabBarItem
        
        let tabBarController = MainTabBarController(HomeVC: homeViewController, ConfigVC: configViewController)
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
