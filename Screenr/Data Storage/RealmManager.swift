
import Foundation
import RealmSwift
import PromiseKit

struct Constants {
    static let defaultSyncHost = "127.0.0.1"
    static let syncAuthURL = URL(string: "http://\(defaultSyncHost):9080")!
    static let syncServerURL = URL(string: "realm://\(defaultSyncHost):9080/")
    static let commonRealmURL = URL(string: "realm://\(defaultSyncHost):9080/CommonRealm")!
    static let privateRealmURL = URL(string: "realm://\(defaultSyncHost):9080/~/privateRealm")!
}

enum RealmConfig {
    
    // MARK: - enum cases
    case common
    case secret
    
    // MARK: - current configuration
    var configuration: Realm.Configuration {
        switch self {
        case .common:
            return RealmConfig.commonRealmConfig(user: SyncUser.current!)
        case .secret:
            return RealmConfig.privateRealmConfig(user: SyncUser.current!)
        }
    }
    
    private static func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.commonRealmURL), objectTypes: [User.self, Movie_R.self, Theatre_R.self, Showtime_R.self])
        return config
    }
    
    private static func privateRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.privateRealmURL), objectTypes: [Theatre_R.self])
        return config
    }
    
}

final class RealmManager {
    
    enum RealmError: Error {
        case existingUserNotLoaded
    }
    
//    static let syncHost = "127.0.0.1"
//    static let syncAuthURL = URL(string: "http://\(syncHost):9080")!
//    static let syncServerURL = URL(string: "realm://\(syncHost):9080/~/screenr")!
    
//    class func loadExistingUser(with syncUser: SyncUser) -> Promise<User> {
//        let realm = try! Realm()
//        return Promise { fullfill, reject in
//            if let user = realm.object(ofType: User.self, forPrimaryKey: syncUser.identity) {
//                fullfill(user)
//            } else {
//                reject(RealmError.existingUserNotLoaded)
//            }
//        }
//    }
    
//    class func createNewUser(syncUser: SyncUser, _ name: String, _ email: String) -> User {
//        let realm = try! Realm()
//        let user = User(syncUser: syncUser, name: name, email: email)
//        try! realm.write {
//            realm.add(user)
//        }
//        return user
//    }
    
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
        user.logOut()
    }
    
//    class func setDefaultRealmConfiguration(with user: SyncUser) {
//        Realm.Configuration.defaultConfiguration = Realm.Configuration(
//            syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL),
//            objectTypes: [User.self, Movie_R.self, Theatre_R.self, Showtime_R.self]
//        )
//    }
    
//    class func setPublicRealmConfiguration(with user: SyncUser) {
//        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
//                                                             appropriateFor: nil, create: false)
//        let url = documentDirectory.appendingPathComponent("public.realm")
//        var config = Realm.Configuration(fileURL: url, syncConfiguration: SyncConfiguration(user: user, realmURL: syncServerURL), readOnly: false, objectTypes: [Theatre_R.self])
//        config.fileURL = url
//        let realm = try! Realm(configuration: config)
//        return realm
//    }
    
    class func login(email: String, password: String) -> Promise<SyncUser> {
        let credentials = SyncCredentials.usernamePassword(username: email, password: password, register: false)
        return Promise { fulfill, reject in
            SyncUser.logIn(with: credentials, server: Constants.syncAuthURL) { syncUser, error in
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
            SyncUser.logIn(with: credentials, server: Constants.syncAuthURL) { syncUser, error in
                if let user = syncUser {
                    fulfill(user)
                }
                if let error = error {
                    reject(error)
                }
            }
        }
    }

    class func addObject<T: Object>(_ object: T, primaryKey: String) {
        let realm = try! Realm(configuration: RealmConfig.common.configuration)
        if let _ = realm.object(ofType: T.self, forPrimaryKey: primaryKey) { return }
        try! realm.write {
            realm.add(object)
        }
    }
    
}
