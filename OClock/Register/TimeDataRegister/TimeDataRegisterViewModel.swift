//
//  TimeDataRegisterViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift
import RxDataSources

enum TimeDataRegisterState {
    case loading
    case success
    case error(_: String)
}

protocol TimeDataRegisterViewModelProtocol {
 
    typealias Target = TimeDataRegisterViewCoordinator.Target

    var state: Observable<TimeDataRegisterState> { get }
    
    var disposeBag: DisposeBag { get }
    
    var totalHoursPickerValue: Observable<HoursModel> { get }
    var totalPauseHoursPickerValue: Observable<HoursModel>  { get }
    var initialHoursPickerValue: Observable<HoursModel>  { get }
    
    var totalHoursTextPH: Observable<String> { get }
    var pauseLabelTextPH: Observable<String> { get }
    var totalPauseHoursTextPH: Observable<String> { get }
    var initialHoursPH: Observable<String> { get }
    var buttonTitle: Observable<String> { get }
    var navigationTarget: Observable<Target> { get }
    var navBarTitle: String { get }
    
    var pauseSwitchValue: AnyObserver<Bool> { get }
   
    var returnedValue: Observable<Bool> { get }
    
    var didReturnHome: AnyObserver<Void> { get }
    var didTapBackButton: AnyObserver<Void> { get }
    var didTapBottomButton: AnyObserver<Void> { get }
    
    var initPickerAdapter: RxPickerViewStringAdapter<[[String]]> { get }
    var totalPickerAdapter: RxPickerViewStringAdapter<[[String]]> { get }
    var pausePickerAdapter: RxPickerViewStringAdapter<[[String]]> { get }
    
    var selectedInit: AnyObserver<(row: Int, component: Int)> { get }
    var selectedTotal: AnyObserver<(row: Int, component: Int)> { get }
    var selectedPause: AnyObserver<(row: Int, component: Int)> { get }
    
    var initText: Observable<String> { get }
    var totalText: Observable<String> { get }
    var pauseText: Observable<String> { get }
    
    var notTrigger: Observable<[Int]> { get }
    
}

class TimeDataRegisterViewModel: TimeDataRegisterViewModelProtocol {

    let totalHoursTextPH: Observable<String>
    let pauseLabelTextPH: Observable<String>
    let totalPauseHoursTextPH: Observable<String>
    let initialHoursPH: Observable<String>
    let buttonTitle: Observable<String>
    let totalHoursPickerValue: Observable<HoursModel>
    let totalPauseHoursPickerValue: Observable<HoursModel>
    let initialHoursPickerValue: Observable<HoursModel>
    let navBarTitle: String = "REGISTRO DE HORAS"
    
    let returnedValue: Observable<Bool>
    
    
    let disposeBag = DisposeBag()
    
    let navigationTarget: Observable<Target>
    let state: Observable<TimeDataRegisterState>
    
    let didReturnHome: AnyObserver<Void>
    let didTapBackButton: AnyObserver<Void>
    let didTapBottomButton: AnyObserver<Void>
    
    let pauseSwitchValue: AnyObserver<Bool>
    
    let selectedInit: AnyObserver<(row: Int, component: Int)>
    let selectedTotal: AnyObserver<(row: Int, component: Int)>
    let selectedPause: AnyObserver<(row: Int, component: Int)>
    
    let initText: Observable<String>
    let totalText: Observable<String>
    let pauseText: Observable<String>
    
    let notTrigger: Observable<[Int]>
    
    let initPickerAdapter = RxPickerViewStringAdapter<[[String]]>(
        components: [],
        numberOfComponents: { _, _, _  in 2 },
        numberOfRowsInComponent: { (_, _, components, component) -> Int in
            return components[component].count
        },
        titleForRow: { (_, pv, components, row, component) -> String? in
            return components[component][row]
        }
    )
    
    let totalPickerAdapter = RxPickerViewStringAdapter<[[String]]>(
        components: [],
        numberOfComponents: { _, _, _  in 2 },
        numberOfRowsInComponent: { (_, _, components, component) -> Int in
            return components[component].count
        },
        titleForRow: { (_, pv, components, row, component) -> String? in
            return components[component][row]
        }
    )
    
    let pausePickerAdapter = RxPickerViewStringAdapter<[[String]]>(
        components: [],
        numberOfComponents: { _, _, _  in 2 },
        numberOfRowsInComponent: { (_, _, components, component) -> Int in
            return components[component].count
        },
        titleForRow: { (_, pv, components, row, component) -> String? in
            return components[component][row]
        }
    )


    
    init(service: TimeDataRegisterViewServiceProtocol = TimeDataRegisterViewService()) {
        
        let _didReturnHome = PublishSubject<Void>()
        didReturnHome = _didReturnHome.asObserver()
        
        let _didTapBackButton = PublishSubject<Void>()
        didTapBackButton = _didTapBackButton.asObserver()
        
        let _didTapBottomButton = PublishSubject<Void>()
        didTapBottomButton = _didTapBottomButton.asObserver()
        
        let _pauseSwitchValue = PublishSubject<Bool>()
        pauseSwitchValue = _pauseSwitchValue.asObserver()
    
        let _state = PublishSubject<TimeDataRegisterState>()
        state = _state.asObserver()
        
        let _selectedInit = PublishSubject<(row: Int, component: Int)>()
        selectedInit = _selectedInit.asObserver()
        
        let _selectedTotal = PublishSubject<(row: Int, component: Int)>()
        selectedTotal = _selectedTotal.asObserver()
        
        let _selectedPause = PublishSubject<(row: Int, component: Int)>()
        selectedPause = _selectedPause.asObserver()
        
        
        totalHoursTextPH = .just("Tempo total de horas de trabalho")
        pauseLabelTextPH = .just("Faz alguma pausa?")
        totalPauseHoursTextPH = .just("Tempo da pausa")
        initialHoursPH = .just("Hora de começo")
        buttonTitle = .just("Registrar")
        
        initialHoursPickerValue = Observable.just(()).map {
            var res: ([String], [String]) = ([], [])
            
            for mnts in 0...59 {
                var min = "\(mnts)"
                if min.count == 1 {
                    min = "0\(min)"
                }
                res.1.append(min)
            }
            
            for hrs in 0...23 {
                var hr = "\(hrs)"
                if hr.count == 1 {
                    hr = "0\(hr)"
                }
                res.0.append("\(hr)")
            }
            
            let hours = HoursModel(hours: res.0, minute: res.1)
            
            return hours
        }
        
        totalHoursPickerValue = Observable.just(()).map {
            var res: ([String], [String]) = ([], [])
            
            for mnts in 0...59 {
                var min = "\(mnts)"
                if min.count == 1 {
                    min = "0\(min)"
                }
                res.1.append(min)
            }
            
            for hrs in 0...12 {
                var hr = "\(hrs)"
                if hr.count == 1 {
                    hr = "0\(hr)"
                }
                res.0.append("\(hr)")
            }
            
            let hours = HoursModel(hours: res.0, minute: res.1)
            
            return hours
        }
        
        totalPauseHoursPickerValue = Observable.just(()).map {
            var res: ([String], [String]) = ([], [])
            
            for mnts in 0...59 {
                var min = "\(mnts)"
                if min.count == 1 {
                    min = "0\(min)"
                }
                res.1.append(min)
            }
            
            for hrs in 0...4 {
                var hr = "\(hrs)"
                if hr.count == 1 {
                    hr = "0\(hr)"
                }
                res.0.append("\(hr)")
            }
            
            let hours = HoursModel(hours: res.0, minute: res.1)
            
            return hours
        }
        
        var inithrs = "00"
        var initmnts = "00"
        initText = _selectedInit.withLatestFrom(initialHoursPickerValue, resultSelector: { component, element in
            let hours = ([element.hours, element.minute])
            if component.component == 0 {
                inithrs = hours[0][component.row]
            } else if component.component == 1 {
                initmnts = hours[1][component.row]
            }
            
            return "\(inithrs):\(initmnts)"
        })
        
        var totalhrs = "00"
        var totalmnts = "00"
        totalText = _selectedTotal.withLatestFrom(totalHoursPickerValue, resultSelector: { component, element in
            let hours = ([element.hours, element.minute])
            if component.component == 0 {
                totalhrs = hours[0][component.row]
            } else if component.component == 1 {
                totalmnts = hours[1][component.row]
            }
            
            return "\(totalhrs):\(totalmnts)"
        })
        
        var pausehrs = "00"
        var pausemnts = "00"
        pauseText = _selectedPause.withLatestFrom(totalPauseHoursPickerValue, resultSelector: { component, element in
            let hours = ([element.hours, element.minute])
            if component.component == 0 {
                pausehrs = hours[0][component.row]
            } else if component.component == 1 {
                pausemnts = hours[1][component.row]
            }
            
            return "\(pausehrs):\(pausemnts)"
        })
        
        returnedValue = _didTapBottomButton
            .withLatestFrom(Observable.combineLatest(_pauseSwitchValue.asObservable().startWith(false),
                                                     totalText.startWith(""),
                                                     pauseText.startWith(""),
                                                     initText.startWith("")))
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
        
        notTrigger = returnedValue.withLatestFrom(initText.asObservable()).map({ hours in
            let sepHours = hours.components(separatedBy: ":")
            if let valOne = sepHours.first, let valTwo = sepHours.last {
                if let valOne = Int(valOne), let valTwo = Int(valTwo) {
                    return [valOne, valTwo]
                } else {
                    return [0, 0]
                }
            } else {
                return [0, 0]
            }
        })
        
        navigationTarget = Observable.merge(
            _didTapBackButton.map { .pop },
            _didReturnHome.map { .returnHome }
        )
    }
}

