//
//  ReportService.swift
//  OClock
//
//  Created by Rafael Hartmann on 16/03/22.
//

import Foundation
import RxSwift
import FirebaseDatabase

enum MyError: Error {
    case myError(String)
}

protocol ReportServiceProtocol {
    func getData() -> Observable<[ReportModel]>
}

class ReportService: ReportServiceProtocol {
    func getData() -> Observable<[ReportModel]> {
       
        return Observable.create { observer in
            RFKDatabase().userReportDataBaseWithoutID.child( RFKDatabase().uid ?? "").queryOrderedByValue().observe(.value, with: { dataSnap in
                var returnData: [ReportModel] = []
                for data in dataSnap.children.allObjects as! [DataSnapshot] {
                    let report = data.value as! [String: AnyObject]
                    let reportFormatted = ReportModel(dictionary: report)
                    returnData.append(reportFormatted)
                }
                observer.onNext(returnData)
            })
            return Disposables.create()
        }
    }
}
