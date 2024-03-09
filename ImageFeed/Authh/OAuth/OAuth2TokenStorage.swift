//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 08.02.2024.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    let keychainWrapper = KeychainWrapper.standard
    let tokenSave = "token"
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenSave)
        }
        set {
            guard let newValue = newValue else { return }
            keychainWrapper.set(newValue, forKey: tokenSave)
        }
    }
    
    func removeToken() {
        keychainWrapper.removeObject(forKey: tokenSave)
    }
}
