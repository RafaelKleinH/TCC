//
//  UserDataViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UserDataViewController: UIViewController {
    
    var viewModel: UserDataViewModelProtocol
    var baseView: UserDataView
    
    init(v: UserDataView, vm: UserDataViewModelProtocol) {
        viewModel = vm
        baseView = v
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
