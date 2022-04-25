//
//  ReportViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 16/03/22.
//

import Foundation
import RxSwift
import RxDataSources

enum ReportState: Equatable {
    case reportError(_: String)
    case reportLoading
    case reportData
}

protocol ReportViewModelProtocol {
    
    var navBarTitle: String { get }
    
    var index: PublishSubject<Int> { get }
    
    var dataSource: Observable<[String]> { get }
    var data: Observable<[ReportModel]> { get }
    var subs: Observable<Void> { get }
   
    var viewDidLoad: AnyObserver<Void> { get }
    var didTap: AnyObserver<Int> { get }
    var state: AnyObserver<ReportState> { get }

    var disposeBag: DisposeBag { get }
    
}

class ReportViewModel: ReportViewModelProtocol {
    
    let navBarTitle: String = "ReportViewNavBarTitle".localized()
    
    var index = PublishSubject<Int>()
    
    let subs: Observable<Void>
    let dataSource: Observable<[String]>
    let data: Observable<[ReportModel]>
    
    let didTap: AnyObserver<Int>
    let viewDidLoad: AnyObserver<Void>
    let state: AnyObserver<ReportState>
    
    let disposeBag = DisposeBag()
    
    init(service: ReportServiceProtocol = ReportService(), navC: UINavigationController) {
        
        let _viewDidLoad = PublishSubject<Void>()
        viewDidLoad = _viewDidLoad.asObserver()
        
        let _didTap = PublishSubject<Int>()
        didTap = _didTap.asObserver()
        
        let _state = PublishSubject<ReportState>()
        state = _state.asObserver()
        
        data = _viewDidLoad.flatMap { _ in
            service.getData()
                .asObservable()
                .observe(on: MainScheduler.instance)
                .do(onNext: { usrdata in
                   
                        _state.onNext(.reportData)
                   
                },
                    onSubscribe: { _state.onNext(.reportLoading) })
                .catchError({ error in
                    _state.onNext(.reportError(error.localizedDescription))
                    return Observable.empty()
                })
            }
            .share()
        
        dataSource = .just(["ReportViewJan".localized(),
                            "ReportViewFeb".localized(),
                            "ReportViewMar".localized(),
                            "ReportViewApr".localized(),
                            "ReportViewMay".localized(),
                            "ReportViewJun".localized(),
                            "ReportViewJul".localized(),
                            "ReportViewAug".localized(),
                            "ReportViewSept".localized(),
                            "ReportViewOct".localized(),
                            "ReportViewNov".localized(),
                            "ReportViewDez".localized()])
             
             subs = _didTap.withLatestFrom(Observable.combineLatest(dataSource, data, index)).map { (string, report, index) in
                     let a = report.filter({ $0.month == "\(index + 1)" })
                     let month = string[index]
                 secReportCoordinator(navigationController: navC, month: month, model: a).start()
                    return ()
             }
    }
}
