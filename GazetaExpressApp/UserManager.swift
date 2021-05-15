//
//  UserManager.swift
//  GazetaExpressApp
//
//  Created by Esra on 12/7/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import Foundation

class UserManager {
    
    static var userInterfaceStyle: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: )
        }
        get {
            return UserDefaults.standard.value(forKey: "USER_TOKEN") as? String
        }
    }
}
