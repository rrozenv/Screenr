
import Foundation
import PromiseKit
import RealmSwift

protocol LoginBusinessLogic {
    func createUser(request: Login.Request)
    func loginUser(request: Login.Request)
}

protocol LoginDataStore {
    var user: User? { get }
}

final class LoginEngine: LoginBusinessLogic, LoginDataStore {
    var user: User?
    var presenter: LoginPresentationLogic?
    
    func createUser(request: Login.Request) {
        RealmManager
            .register(email: request.email, password: request.password)
            .then { [weak self] (syncUser) -> Void in
                self?.initializeCommonRealm(completion: { [weak self] (isSuccess) in
                    if isSuccess {
                        let user = User.loadUser(request.name!, request.email)
                        let response = Login.Response(user: user)
                        self?.presenter?.presentNewUserMessage(response: response)
                    } else {
                        let response = Login.Response(user: nil)
                        self?.presenter?.presentNewUserMessage(response: response)
                    }
                })
            }
            .catch { [weak self] (error) -> Void in
                print(error.localizedDescription)
                let response = Login.Response(user: nil)
                self?.presenter?.presentNewUserMessage(response: response)
        }
    }
    
    func loginUser(request: Login.Request) {
        RealmManager
            .login(email: request.email, password: request.password)
            .then { [weak self] (syncUser) -> Void in
                self?.initializeCommonRealm(completion: { [weak self] (isSuccess) in
                    if isSuccess {
                        let user = User.loadUser(request.name ?? "", request.email)
                        let response = Login.Response(user: user)
                        self?.presenter?.presentExistingUserMessage(response: response)
                    } else {
                        let response = Login.Response(user: nil)
                        self?.presenter?.presentNewUserMessage(response: response)
                    }
                })
            }
            .catch { [weak self] (error) -> Void in
                print(error.localizedDescription)
                let response = Login.Response(user: nil)
                self?.presenter?.presentExistingUserMessage(response: response)
        }
    }
    
}

extension LoginEngine {
    
    func initializeCommonRealm(completion: @escaping (Bool) -> Void) {
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
    
    func setPermissionForRealm(_ realm: Realm?, accessLevel: SyncAccessLevel, personID: String) {
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
