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
