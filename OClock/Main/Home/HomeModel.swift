//
//  HomeModel.swift
//  OClock
//
//  Created by Rafael Hartmann on 14/01/22.
//

import Foundation

class PersonalData {
    var name: String!
    var occupation: String!
    var photo: String!
    var email: String!
    
    init(dictionary: [String: Any]) {
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        
        if let occupation = dictionary["occupation"] as? String {
            self.occupation = occupation
        }
        
        if let photo = dictionary["foto"] as? String {
            self.photo = photo
        }
        
     }
}

class HoursData {
    var startHours: String!
    var hasBreak: Bool!
    var totalBreakTime: String!
    var totalHours: String!
    
    init(dictionary: [String: Any]) {
        
        if let startHours = dictionary["sttartHour"] as? String {
            self.startHours = startHours
        }
        
        if let hasBreak = dictionary["hasBreak"] as? Bool {
            self.hasBreak = hasBreak
        }
        
        if let totalBreakTime = dictionary["breakTime"] as? String {
            self.totalBreakTime = totalBreakTime
        }
        
        if let totalHours = dictionary["totalHours"] as? String {
            self.totalHours = totalHours
        }
    }
}
