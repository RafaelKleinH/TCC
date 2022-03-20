//
//  secReportCoordinator.swift
//  OClock
//
//  Created by Rafael Hartmann on 19/03/22.
//

import Foundation
import UIKit

class secReportCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var month: String
    var model: [ReportModel]
    
    
    init(navigationController: UINavigationController, month: String, model: [ReportModel]){
        self.navigationController = navigationController
        self.month = month
        self.model = model
    }
    
    func start() {
        let v = SecReportView()
        let vm = SecReportViewModel(monthModel: month, model: model)
        let vc = SecReportViewController(v: v, vm: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}
