//
//  RealmManager.swift
//  Screenr
//
//  Created by Robert Rozenvasser on 10/23/17.
//  Copyright © 2017 GoKid. All rights reserved.
//

import Foundation
import RealmSwift
import PromiseKit

class User: Object {
    
    // MARK: - Properties
    dynamic var id = UUID().uuidString
    dynamic var name: String = ""
    dynamic var email: String = ""
    
    // MARK: - Init
    convenience init(name: String, email: String) {
        self.init()
        self.name = name
        self.email = email
    }
    
    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "id"
    }

}

final class RealmManager {
    
    static let syncHost = "127.0.0.1"
    static let syncAuthURL = URL(string: "http://\(syncHost):9080")!
    static let syncServerURL = URL(string: "realm://\(syncHost):9080/~/screenr")!
    static let realm: Realm = try! Realm()
    
    class func isUserLoggedIn() -> SyncUser? {
        guard let syncUser = SyncUser.current else {
            return nil
        }
        return syncUser
    }
    
    class func isDefaultRealmConfigured() -> Bool {
        return try! !Realm().isEmpty
    }
    
    class func resetDefaultRealm() {
        guard let user = SyncUser.current else { return }
        //deduplicationNotificationToken.stop()
        user.logOut()
    }
    
    class func setDefaultRealmConfiguration(with user: SyncUser) {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL),
            objectTypes: [User.self, Movie.self, Theatre.self, Showtime.self]
        )
    }
    
    class func login(email: String, password: String) -> Promise<SyncUser> {
        let credentials = SyncCredentials.usernamePassword(username: email, password: password, register: false)
        return Promise { fulfill, reject in
            SyncUser.logIn(with: credentials, server: syncAuthURL) { syncUser, error in
                if let user = syncUser {
                    fulfill(user)
                }
                if let error = error {
                   reject(error)
                }
            }
        }
    }
    
    class func register(email: String, password: String) -> Promise<SyncUser> {
        let credentials = SyncCredentials.usernamePassword(username: email, password: password, register: true)
        return Promise { fulfill, reject in
            SyncUser.logIn(with: credentials, server: syncAuthURL) { syncUser, error in
                if let user = syncUser {
                    fulfill(user)
                }
                if let error = error {
                    reject(error)
                }
            }
        }
    }

    class func addObject(_ object: Movie, primaryKey: String)   {
        if let _ = realm.object(ofType: Movie.self, forPrimaryKey: primaryKey) { return }
        try! self.realm.write {
            realm.add(object)
            print("Added new object")
        }
    }
    
}
