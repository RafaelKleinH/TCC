//
//  DataBase.swift
//  OClock
//
//  Created by Rafael Hartmann on 17/01/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RFKDatabase {
    
    let ref = Database.database().reference()
    let userDataBase = "user"
    
    var userDataBaseWithUID: DatabaseReference
    
    let uid = Auth.auth().currentUser?.uid
    
    init() {
        userDataBaseWithUID = ref.child(userDataBase).child(uid ?? "")
    }
    
    
    
}
