
import Foundation
import RealmSwift
import PromiseKit

final class RealmLoginManager {
    
    class func isUserLoggedIn() -> SyncUser? {
        guard let syncUser = SyncUser.current else {
            return nil
        }
        return syncUser
    }
    
    class func resetDefaultRealm() {
        guard let user = SyncUser.current else { return }
        user.logOut()
    }
    
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
    
    class func initializeCommonRealm(completion: @escaping (Bool) -> Void) {
        Realm.asyncOpen(configuration: RealmConfig.common.configuration, callback: { (realm, error) in
            if let realm = realm {
                if SyncUser.current?.isAdmin == true {
                    self.setPermissionForRealm(realm, accessLevel: .write, personID: "*")
                }
                completion(true)
            }
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
        })
    }
    
    class func setPermissionForRealm(_ realm: Realm?, accessLevel: SyncAccessLevel, personID: String) {
        if let realm = realm {
            let perm = SyncPermission(realmPath: realm.configuration.syncConfiguration!.realmURL.path,
                                      identity: personID,
                                      accessLevel: accessLevel)
            SyncUser.current?.apply(perm) { error in
                if let error = error {
                    print("Error when attempting to set permissions: \(error.localizedDescription)")
                    return
                } else {
                    print("Permissions successfully set")
                }
            }
        }
    }
    
}
