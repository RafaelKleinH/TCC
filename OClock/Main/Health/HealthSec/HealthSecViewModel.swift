//
//  HealthSecViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 01/04/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol HealthSecViewModelProtocol {
    
    var rowSelected: Observable<Int> { get }
    var data: Observable<[HealthSec]> { get }
    
    var navBarTitle: String { get }
    
    var disposeBag: DisposeBag { get }
}

class HealthSecViewModel: HealthSecViewModelProtocol {
 
    let rowSelected: Observable<Int>
    let data: Observable<[HealthSec]>
    
    var navBarTitle: String
    
    let disposeBag: DisposeBag = DisposeBag()
    
    init(service: HealthSecServiceProtocol = HealthSecService(), selectedRow: Int) {
        
        rowSelected = .just(selectedRow)
        
        navBarTitle = "secHealthNavBarTitle\(selectedRow)".localized()
        
        data = rowSelected.map { row in
            
            var array: [HealthSec] = []
            
            if row == 0 {
                let healthWhy = HealthSec(imageName: nil, text: "secHealthWhyText".localized())
                array.append(healthWhy)
            } else if row == 1 {
                for num in 1...5 {
                    let helthalng = HealthSec(imageName: "secHealthAlng\(num)Photo".localized(), text: "secHealthAlng\(num)Text".localized())
                    array.append(helthalng)
                }
            } else if row == 2 {
                for num in 6...10 {
                    let helthalng = HealthSec(imageName: "secHealthAlng\(num)Photo".localized(), text: "secHealthAlng\(num)Text".localized())
                    array.append(helthalng)
                }
            } else if row == 3 {
                let helthalng = HealthSec(imageName: nil, text: "secHealthTypeText".localized())
                array.append(helthalng)
            }
            return array
        }
    }
}
