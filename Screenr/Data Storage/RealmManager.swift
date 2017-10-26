
import Foundation
import RealmSwift
import PromiseKit

class User: Object {
    
    // MARK: - Properties
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var email: String = ""
    
    // MARK: - Init
    convenience init(syncUser: SyncUser, name: String, email: String) {
        self.init()
        self.id = syncUser.identity ?? ""
        self.name = name
        self.email = email
    }
    
    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "id"
    }

}

final class RealmManager {
    
    enum RealmError: Error {
        case userNotLoaded
    }
    
    static let syncHost = "127.0.0.1"
    static let syncAuthURL = URL(string: "http://\(syncHost):9080")!
    static let syncServerURL = URL(string: "realm://\(syncHost):9080/~/screenr")!
    
    class func loadExistingUser(with syncUser: SyncUser) -> Promise<User> {
        let realm = try! Realm()
        return Promise { fullfill, reject in
                if let user = realm.object(ofType: User.self, forPrimaryKey: syncUser.identity) {
                   fullfill(user)
                } else {
                    reject(RealmError.userNotLoaded)
                }
        }
    }
    
    class func createNewUser(syncUser: SyncUser, _ name: String, _ email: String) -> User {
        let realm = try! Realm()
        let user = User(syncUser: syncUser, name: name, email: email)
        //UserDefaults.standard.set(syncUser.identity, forKey: "userID")
        try! realm.write {
            realm.add(user)
        }
        return user
    }
    
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

    class func addObject<T: Object>(_ object: T, primaryKey: String) {
        let realm = try! Realm()
        if let _ = realm.object(ofType: T.self, forPrimaryKey: primaryKey) { return }
        try! realm.write {
            realm.add(object)
            print("Added new object")
        }
    }
    
}
