//
//  PreRegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 23/02/22.
//

import Foundation
import RxSwift
import RxCocoa



protocol PreRegisterViewModelProtocol {
    
    typealias Target = PreRegisterCoordinator.Target
    var navigationTarget: Observable<Target> { get }
    
    var didTapBottomButton: AnyObserver<Void> { get }
    
    var titleLabelText: Observable<String> { get }
    var textLabelText: Observable<String> { get }
    var confirmButtonText: Observable<String> { get }
    
    var myDisposeBag: DisposeBag { get }
}

class PreRegisterViewModel: PreRegisterViewModelProtocol {
    
    let navigationTarget: Observable<Target>
    
    let didTapBottomButton: AnyObserver<Void>
    
    let titleLabelText: Observable<String>
    let textLabelText: Observable<String>
    let confirmButtonText: Observable<String>
    
    let myDisposeBag = DisposeBag()
    
    init() {
        
        titleLabelText = .just("preRegisterViewTitle".localized())
        textLabelText = .just("preRegisterText".localized())
        confirmButtonText = .just("preRegisterButtonText".localized())
        
        let _didTapBottomButton = PublishSubject<Void>()
        didTapBottomButton = _didTapBottomButton.asObserver()
        
        navigationTarget = Observable.merge(
            _didTapBottomButton.map({ .nextView })
        )
    }
}
