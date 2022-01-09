//
//  PersonalRegisterViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class PersonalRegisterViewController: UIViewController {
    
    var viewModel: PersonalRegisterViewModelProtocol
    var baseView: PersonalRegisterView
    
    
    init(viewModel: PersonalRegisterViewModel, baseView: PersonalRegisterView) {
        self.viewModel = viewModel
        self.baseView = baseView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
