//
//  TimeDataRegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift

enum TimeDataRegisterState {
    case loading
    case success
    case error(_: String)
}

protocol TimeDataRegisterViewModelProtocol {
 
    typealias Target = TimeDataRegisterViewCoordinator.Target
 
    var state: Observable<TimeDataRegisterState> { get }
    
    var disposeBag: DisposeBag { get }
    
    var totalHoursTextPH: Observable<String> { get }
    var pauseLabelTextPH: Observable<String> { get }
    var totalPauseHoursTextPH: Observable<String> { get }
    var initialHoursPH: Observable<String> { get }
    var buttonTitle: Observable<String> { get }
    var subPauseSwitchValue: Observable<Bool> { get }
    var navigationTarget: Observable<Target> { get }
    var navBarTitle: String { get }
    
    var totalHoursTFValue: AnyObserver<String> { get }
    var pauseSwitchValue: AnyObserver<Bool> { get }
    var pauseHoursTFValue: AnyObserver<String> { get }
    var initialHoursTFValue: AnyObserver<String> { get }
   
    var returnedValue: Observable<Bool> { get }
    
    var didReturnHome: AnyObserver<Void> { get }
    var didTapBackButton: AnyObserver<Void> { get }
    var didTapBottomButton: AnyObserver<Void> { get }
}

class TimeDataRegisterViewModel: TimeDataRegisterViewModelProtocol {
    
    let totalHoursTextPH: Observable<String>
    let pauseLabelTextPH: Observable<String>
    let totalPauseHoursTextPH: Observable<String>
    let initialHoursPH: Observable<String>
    let buttonTitle: Observable<String>
    let navBarTitle: String = "REGISTRO DE HORAS"
    
    let returnedValue: Observable<Bool>
    
    let subPauseSwitchValue: Observable<Bool>
    
    let disposeBag = DisposeBag()
    
    let navigationTarget: Observable<Target>
    let state: Observable<TimeDataRegisterState>
    
    let didReturnHome: AnyObserver<Void>
    let didTapBackButton: AnyObserver<Void>
    let didTapBottomButton: AnyObserver<Void>
    
    let totalHoursTFValue: AnyObserver<String>
    let pauseSwitchValue: AnyObserver<Bool>
    let pauseHoursTFValue: AnyObserver<String>
    let initialHoursTFValue: AnyObserver<String>
    
    init(service: TimeDataRegisterViewServiceProtocol = TimeDataRegisterViewService()) {
        
        let _didReturnHome = PublishSubject<Void>()
        didReturnHome = _didReturnHome.asObserver()
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _didTapBottomButton = PublishSubject<Void>()
        didTapBottomButton = _didTapBottomButton.asObserver()
        
        let _pauseSwitchValue = PublishSubject<Bool>()
        pauseSwitchValue = _pauseSwitchValue.asObserver()
        
        let _totalHoursTFValue = PublishSubject<String>()
        totalHoursTFValue = _totalHoursTFValue.asObserver()
        
        let _pauseHoursTFValue = PublishSubject<String>()
        pauseHoursTFValue = _pauseHoursTFValue.asObserver()
        
        let _initialHoursTFValue = PublishSubject<String>()
        initialHoursTFValue = _initialHoursTFValue.asObserver()
        
        let _state = PublishSubject<TimeDataRegisterState>()
        state = _state.asObserver()
        
        totalHoursTextPH = .just("Tempo total de horas de trabalho")
        pauseLabelTextPH = .just("Faz alguma pausa?")
        totalPauseHoursTextPH = .just("Tempo da pausa")
        initialHoursPH = .just("Hora de começo")
        buttonTitle = .just("Registrar")
        
        subPauseSwitchValue = _pauseSwitchValue.startWith(false).map {
            if !$0 {
                _pauseHoursTFValue.onNext("0")
            }
            return $0
        }
        
        returnedValue = _didTapBottomButton
            .withLatestFrom(Observable.combineLatest(_pauseSwitchValue.asObservable(),
                                                     _totalHoursTFValue.asObservable(),
                                                     _pauseHoursTFValue.asObservable(),
                                                     _initialHoursTFValue.asObservable()))
            .flatMapLatest { hasBreak, totalHours, totalBreakHours, initHours in
                service
                    .postInformations(totalH: totalHours, hasBreak: hasBreak, breakTime: totalBreakHours, startTime: initHours)
                    .asObservable()
                    .observe(on: MainScheduler.instance)
                    .do(onNext: { _ in _state.onNext(.success) },
                        onSubscribe: { _state.onNext(.loading) })
                    .catchError { error in
                        _state.onNext(.error(error.localizedDescription))
                        return Observable.empty()
                    }
            }.share()
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop },
            _didReturnHome.map { .returnHome }
        )
    }
}

