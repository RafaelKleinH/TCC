//
//  ReportViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 16/03/22.
//

import Foundation
import RxSwift
import RxDataSources

protocol ReportViewModelProtocol {
    
    var viewDidLoad: AnyObserver<Void> { get }
    
    var dataSource: Observable<[String]> { get }
    
    var disposeBag: DisposeBag { get }
}

class ReportViewModel: ReportViewModelProtocol {
    
    let viewDidLoad: AnyObserver<Void>
    
    let dataSource: Observable<[String]>
    
    let disposeBag = DisposeBag()
    
    init(service: ReportServiceProtocol = ReportService()) {
        
        let _viewDidLoad = PublishSubject<Void>()
        viewDidLoad = _viewDidLoad.asObserver()
        
        dataSource = .just(
             ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
        )
    }
}
