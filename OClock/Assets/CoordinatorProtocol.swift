//
//  CoordinatorProtocol.swift
//  O`Clock
//
//  Created by Rafael Hartmann on 10/11/21.
//

import Foundation
import UIKit

public protocol CoordinatorProtocol {
    
    var navigationController: UINavigationController { get }
    
    func start()
    
}


