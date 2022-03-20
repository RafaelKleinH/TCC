//
//  secReportViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 19/03/22.
//

import Foundation
import RxSwift

protocol SecReportViewModelProtocol {
    var report: Observable<[ReportModel]> { get }
    var month: Observable<String> { get }
    var totalHours: Observable<String> { get }
    var disposebag: DisposeBag { get }
}

class SecReportViewModel: SecReportViewModelProtocol {
   
    let report: Observable<[ReportModel]>
    
    let month: Observable<String>
    
    let totalHours: Observable<String>
    
    let disposebag = DisposeBag()
    
    init(monthModel: String, model: [ReportModel]) {
        report = .just(model)
        month = .just(monthModel)
        
        totalHours = report.map({ report in
            var hours = 0
            for rep in report {
                hours += rep.totalHours
            }
        
            return hours.toSec()
        })
    }
}

extension Int {
    func toSec() -> String {
        let base = "\(self / 3600):\((self % 3600) / 60):\((self % 3600) % 60)"
        let arrays = base.components(separatedBy: ":")
        var correctArray: [String] = []
        for b in arrays {
            correctArray.append(b.count != 1 ? b : "0\(b)")
        }
        return "\(correctArray[0]):\(correctArray[1]):\(correctArray[2])"
    }
}
