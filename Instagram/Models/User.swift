//
//  User.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation
import Unbox
import RealmSwift

class User: Object, Unboxable {
    // MARK: - Properties
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var fullName: String = ""
    @objc dynamic var profilePicture: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Unboxer
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "username")
        fullName = try unboxer.unbox(key: "full_name")
        profilePicture = try unboxer.unbox(key: "profile_picture")
    }
    
    
}
