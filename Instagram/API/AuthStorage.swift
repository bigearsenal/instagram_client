//
//  AuthStorage.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct AuthStorage {
    private static let KEYCHAIN_TOKEN_KEY = "KEYCHAIN_TOKEN_KEY"
    static var token: String? = KeychainWrapper.standard.string(forKey: KEYCHAIN_TOKEN_KEY) {
        willSet {
            guard let value = newValue else {
                KeychainWrapper.standard.remove(key: KEYCHAIN_TOKEN_KEY)
                return
            }
            KeychainWrapper.standard.set(value, forKey: KEYCHAIN_TOKEN_KEY)
        }
    }
}
