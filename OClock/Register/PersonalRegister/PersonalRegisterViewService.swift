
//
//  PersonalRegisterViewService.swift
//  OClock
//
//  Created by Rafael Hartmann on 08/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


protocol PersonalRegisterViewServiceProtocol {
    func postInformations(name: String, occupation: String, image: UIImage) -> Observable<Bool>
    func getImage() ->Observable<UIImage>
}

class PersonalRegisterViewService: PersonalRegisterViewServiceProtocol {
    func postInformations(name: String, occupation: String, image: UIImage) -> Observable<Bool> {
        
        return Observable.create { observer in
            let uid = Auth.auth().currentUser?.uid
            let imageData = image.pngData()
            if let img = imageData {
                if let uid = uid {
                    UserDefaults.standard.set(img, forKey: "profImg\(uid)")
                }
            }
            RFKDatabase().userDataBaseWithUID.updateChildValues(["name": name, "occupation": occupation, "profileImage": "image"]) { (error, db) in
                if let error = error {
                    observer.onError(error)
                } else {
                    
                    observer.onNext(true)
                    UserDefaults.standard.set(true, forKey: UserDefaultValue.NEED_RELOAD.rawValue)
                }
                observer.onCompleted()
            }
            return Disposables.create()
            
        }
    }
    
    func getImage() ->Observable<UIImage> {
            return Observable.create { observer in
                guard let uid = Auth.auth().currentUser?.uid else { return Disposables.create() }
                let imgData = UserDefaults.standard.data(forKey: "profImg\(uid)")
                if let imgData = imgData {
                    let uiimage = UIImage(data: imgData)
                    if let uiimage = uiimage {
                        observer.onNext(uiimage)
                    }
                }
            return Disposables.create()
        }
    }
}

