//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 08.02.2024.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    let userDefaults = UserDefaults.standard
    let keychainWrapper = KeychainWrapper.standard
    let tokenSave = "token"
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenSave)
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = keychainWrapper.set(newValue, forKey: tokenSave)
            guard isSuccess else {
                fatalError("Ошибка сохранения токена")
            }
        }
    }
}
