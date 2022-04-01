//
//  ResetViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 25/03/22.
//

import Foundation
import RxSwift

enum ResetViewState {
    case loading
    case error
    case success
}

enum ResetTextFieldState {
    case isntMail
    case isntEqual
    case isEmptyF
    case isEmptyS
    case success
}

protocol ResetViewModelProtocol {
    var myDisposeBag: DisposeBag { get }
    var state: Observable<ResetViewState> { get }
    var tfState: Observable<ResetTextFieldState> { get }
    
    var didTapNavigationBackButtom: AnyObserver<Void> { get }
    var didTapBottomButton: AnyObserver<Void> { get }
    var didSuccessTFValidations: AnyObserver<Void> { get }
    var emailText: AnyObserver<String> { get }
    var confirmEmailText: AnyObserver<String> { get }
    
    var buttonReturn: Observable<Void> { get }
    
    var emailBindText: Observable<String> { get }
    var confirmEmailBindText: Observable<String> { get }
    var bottomButtonText: Observable<String> { get }
    
    var returnTF: Observable<Void> { get }
}

class ResetViewModel: ResetViewModelProtocol {
    
    let myDisposeBag = DisposeBag()
    let state: Observable<ResetViewState>
    let tfState: Observable<ResetTextFieldState>
    
    let didTapNavigationBackButtom: AnyObserver<Void>
    let didTapBottomButton: AnyObserver<Void>
    let emailText: AnyObserver<String>
    let confirmEmailText: AnyObserver<String>
    let didSuccessTFValidations: AnyObserver<Void>
    let buttonReturn: Observable<Void>
    
    let emailBindText: Observable<String>
    let confirmEmailBindText: Observable<String>
    let bottomButtonText: Observable<String>
    
    let returnTF: Observable<Void>
    
    init(service: ResetServiceProtocol = ResetService()) {
        
        emailBindText = .just("ResetPasswordEmail".localized())
        confirmEmailBindText = .just("ResetPasswordConfirmEmail".localized())
        bottomButtonText = .just("ResetPasswordButton".localized())
        
        let _didTapNavigationBackButtom = PublishSubject<Void>()
        didTapNavigationBackButtom = _didTapNavigationBackButtom.asObserver()
        
        let _didTapBottomButton = PublishSubject<Void>()
        didTapBottomButton = _didTapBottomButton.asObserver()
        
        let _emailText = PublishSubject<String>()
        emailText = _emailText.asObserver()
        
        let _confirmEmailText = PublishSubject<String>()
        confirmEmailText = _confirmEmailText.asObserver()
        
        let _state = PublishSubject<ResetViewState>()
        state = _state.asObserver()
        
        let _tfState = PublishSubject<ResetTextFieldState>()
        tfState = _tfState.asObserver()
        
        let _didSuccessTFValidations = PublishSubject<Void>()
        didSuccessTFValidations = _didSuccessTFValidations.asObserver()
        
        
        
        returnTF = _didTapBottomButton.withLatestFrom(Observable.combineLatest( _emailText.asObservable().startWith(""), _confirmEmailText.asObservable().startWith("")))
            .map { email, confirm in
                if email == ""  {
                    _tfState.onNext(.isEmptyF)
                } else if confirm == "" {
                    _tfState.onNext(.isEmptyS)
                } else if email != confirm {
                    _tfState.onNext(.isntEqual)
                } else if email.isValidEmail() == false {
                    _tfState.onNext(.isntMail)
                } else {
                    _tfState.onNext(.success)
                }
            }.share()
        
        buttonReturn = _didSuccessTFValidations.withLatestFrom(_emailText.asObservable()).flatMap { email in
            
          
            
            service.resetEmail(with: email)
                .asObservable()
                .observe(on: MainScheduler.instance)
                .do { _ in
                    _state.onNext(.success)
                } onError: { error in
                    _state.onNext(.error)
                } onSubscribe: {
                    _state.onNext(.loading)
                }
        }.share()
        
    }
    
}
