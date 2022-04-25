//
//  HealthViewController.swift
//  OClock
//
//  Created by Rafael Hartmann on 15/03/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

class HealthViewController: UIViewController {
    
    var baseView: HealthView
    var viewModel: HealthViewModelProtocol
    
    init(v: HealthView, vm: HealthViewModelProtocol) {
        baseView = v
        viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        baseView.tableView.rx.setDelegate(self).disposed(by: viewModel.myDisposeBag)
        rxBind()
        viewModel.didLoad.onNext(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        styleNavBar(navTitle: viewModel.navBarTitle)
        super.viewWillAppear(animated)
    }
    
    func rxBind() {
        
        viewModel.explicationOpenText
            .bind(to: baseView.explicationOpen.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.explicationText
            .bind(to: baseView.explicationLabel.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.switchLabelText
            .bind(to: baseView.switchLabel.rx.text)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.healthSwitch
            .rx
            .isOn
            .bind(to: viewModel.isOn)
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.isOnOpen
            .bind(to: baseView.healthSwitch.rx.isOn)
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.explicationOpen
            .rx
            .gesture(.tap(configuration: nil))
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3) {
                    self.baseView.explanationaView.isHidden = !self.viewModel.isOpen
                    self.baseView.explicationLabel.alpha = !self.viewModel.isOpen ? 0 : 1
                  
                    self.viewModel.isOpen.toggle()
                }
            })
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.titles
            .bind(to: baseView.tableView.rx.items(cellIdentifier: HealthTableViewCell.description(), cellType: HealthTableViewCell.self)) { index, element, cell in
                cell.healthLabel.text = element
            }
            .disposed(by: viewModel.myDisposeBag)
        
        viewModel.dataReceive
            .subscribe()
            .disposed(by: viewModel.myDisposeBag)
        
        baseView.tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.selectedRow.onNext(indexPath.row)
                self?.viewModel.didTapTableViewCell.onNext(())
            })
            .disposed(by: viewModel.myDisposeBag)
        
    }
}

extension HealthViewController: UITableViewDelegate {

}
