//
//  TimeDataRegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift

protocol TimeDataRegisterViewModelProtocol {
 
    typealias Target = TimeDataRegisterViewCoordinator.Target
 
    var disposeBag: DisposeBag { get }
    
    var totalHoursTextPH: Observable<String> { get }
    var pauseLabelTextPH: Observable<String> { get }
    var totalPauseHoursTextPH: Observable<String> { get }
    var initialHoursPH: Observable<String> { get }
    var buttonTitle: Observable<String> { get }
    
    var pauseSwitchValue: AnyObserver<Bool> { get }
    var subPauseSwitchValue: Observable<Bool> { get }
    
    var navigationTarget: Observable<Target> { get }
    
    var didTapBackButton: AnyObserver<Void> { get }
    var didTapBottomButton: AnyObserver<Void> { get }
}

class TimeDataRegisterViewModel: TimeDataRegisterViewModelProtocol {
    
    let totalHoursTextPH: Observable<String>
    let pauseLabelTextPH: Observable<String>
    let totalPauseHoursTextPH: Observable<String>
    let initialHoursPH: Observable<String>
    let buttonTitle: Observable<String>
    
    let subPauseSwitchValue: Observable<Bool>
    
    let disposeBag = DisposeBag()
    
    let navigationTarget: Observable<Target>
    
    let didTapBackButton: AnyObserver<Void>
    let didTapBottomButton: AnyObserver<Void>
    let pauseSwitchValue: AnyObserver<Bool>
    
    init() {
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _didTapBottomButton = PublishSubject<Void>()
        didTapBottomButton = _didTapBottomButton.asObserver()
        
        let _pauseSwitchValue = PublishSubject<Bool>()
        pauseSwitchValue = _pauseSwitchValue.asObserver()
        
        totalHoursTextPH = .just("Tempo total de horas de trabalho")
        pauseLabelTextPH = .just("Faz alguma pausa?")
        totalPauseHoursTextPH = .just("Tempo da pausa")
        initialHoursPH = .just("Hora de começo")
        buttonTitle = .just("Registrar")
        
        
        subPauseSwitchValue = _pauseSwitchValue.map { $0 }
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop }
        )
    }
}

