
import Foundation
import UIKit


class MainTabBarController: UITabBarController {
    
    let homeVC: HomeViewController
    let configVC: ConfigViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .black
        setViewControllers([homeVC, configVC], animated: true)
    }
    
    init(HomeVC: HomeViewController, ConfigVC: ConfigViewController) {
        homeVC = HomeVC
        configVC = ConfigVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
