//
//  Post.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation
import RealmSwift
import Unbox

class Post: Object, Unboxable {
    @objc dynamic var id: String = ""
    @objc dynamic var thumbnail: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var caption: String? = nil
    @objc dynamic var user: User? = nil
    @objc dynamic var likesCount: Int32 = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        
        id = try unboxer.unbox(key: "id")
        thumbnail = try unboxer.unbox(keyPath: "images.thumbnail.url")
        image = try unboxer.unbox(keyPath: "images.standard_resolution.url")
        caption = try? unboxer.unbox(keyPath: "caption.text")
        likesCount = try unboxer.unbox(keyPath: "likes.count")
        user = try? unboxer.unbox(keyPath: "caption.from")
    }
}
