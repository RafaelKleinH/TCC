//
//  ConfigViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 18/01/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ConfigViewController: UIViewController {
    
    var viewModel: ConfigViewModelProtocol
    var baseView: ConfigView
    
    override func viewDidLoad() {
        view = baseView 
    }
    
    init(v: ConfigView, vm: ConfigViewModelProtocol) {
        viewModel = vm
        baseView = v
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rxBinds() {
        viewModel.timer
            .subscribe(onNext: { [baseView] time in
                baseView.clockLabel.text = "\(time)"
            })
            .disposed(by: DisposeBag())
    }
}
