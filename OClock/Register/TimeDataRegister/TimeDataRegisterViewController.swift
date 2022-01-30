//
//  TimeDataRegisterViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit

class TimeDataRegisterViewController: UIViewController {
    
    var viewModel: TimeDataRegisterViewModelProtocol
    var baseView: TimeDataRegisterView
    
    init(vm: TimeDataRegisterViewModelProtocol, bv: TimeDataRegisterView) {
        viewModel = vm
        baseView = bv
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        view = baseView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
