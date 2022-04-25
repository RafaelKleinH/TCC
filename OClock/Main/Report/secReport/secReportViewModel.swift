//
//  secReportViewModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 19/03/22.
//

import Foundation
import RxSwift

protocol SecReportViewModelProtocol {
    var totalHoursDumb: String { get set }
    var pdfCreator: PDFCreator { get }
    var report: Observable<[ReportModel]> { get }
    var month: Observable<String> { get }
    var totalHours: Observable<String> { get }
    var totalHoursLabelText: Observable<String> { get }
    var disposebag: DisposeBag { get }
}

class SecReportViewModel: SecReportViewModelProtocol {
   
    var pdfCreator: PDFCreator
    var totalHoursDumb: String = ""
    
    let report: Observable<[ReportModel]>
    let month: Observable<String>
    let totalHours: Observable<String>
    let totalHoursLabelText: Observable<String>
    let disposebag = DisposeBag()
    
    init(monthModel: String, model: [ReportModel]) {
        report = .just(model)
        month = .just(monthModel)
        
        pdfCreator = PDFCreator(monthI: monthModel, reportDataI: model)
        
        totalHoursLabelText = .just("SecReportViewTotalHoursSuport".localized())
        
        totalHours = report.map({ report in
            var hours = 0
            for rep in report {
                hours += rep.totalHours
            }
            return hours.toSec()
        })
    }
}


