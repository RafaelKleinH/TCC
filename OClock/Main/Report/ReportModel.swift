//
//  ReportModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 19/03/22.
//

import Foundation

class ReportModel {
    var endDay: String!
    var endHours: String!
    var endWeekday: String!
    var initialDay: String!
    var initialHours: String!
    var initialWeekday: String!
    var intervalTotalHours: Int!
    var month: String!
    var totalHours: Int!
    
    init(dictionary: [String: Any]) {
        
        if let endDay = dictionary["endDay"] as? String {
            self.endDay = endDay
        }
        if let endHours = dictionary["endHours"] as? String {
            self.endHours = endHours
        }
        if let endWeekday = dictionary["endWeekday"] as? String {
            self.endWeekday = endWeekday
        }
        if let initWeekDay = dictionary["initWeekday"] as? String {
            self.initialWeekday = initWeekDay
        }
        
        if let initDay = dictionary["initialDay"] as? String {
            self.initialDay = initDay
        }
        
        if let initHours = dictionary["initialHours"] as? String {
            self.initialHours = initHours
        }
        
        if let intervalTotalHours = dictionary["intervalTotalHours"] as? Int{
            self.intervalTotalHours = intervalTotalHours
        }
        
        if let month = dictionary["month"] as? String{
            self.month = month
        }
        
        if let totalHours = dictionary["totalHours"] as? Int{
            self.totalHours = totalHours
        }
        
     }
}
