//
//  RealmMigration.swift
//  github
//
//  Created by Chung Tran on 31/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//
import RealmSwift

func migrateRealm() {
    let config = Realm.Configuration(
        schemaVersion: 1,
        migrationBlock: {migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: Post.className(), { (_, newObject) in
                    newObject!["likesCount"] = UInt32(0)
                })
            }
    })
    Realm.Configuration.defaultConfiguration = config
}
