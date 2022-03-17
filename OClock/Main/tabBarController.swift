
import Foundation
import UIKit
import CBFlashyTabBarController

class MainTabBarController: CBFlashyTabBarController {
    
    let homeVC: HomeViewController
    let reportVC: ReportViewController
    let healthVC: HealthViewController
    let configVC: ConfigViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .black
        setViewControllers([homeVC, reportVC, healthVC, configVC], animated: true)
    }
    
    init(HomeVC: HomeViewController, ReportVC: ReportViewController, HealthVC: HealthViewController, ConfigVC: ConfigViewController) {
        homeVC = HomeVC
        reportVC = ReportVC
        healthVC = HealthVC
        configVC = ConfigVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
