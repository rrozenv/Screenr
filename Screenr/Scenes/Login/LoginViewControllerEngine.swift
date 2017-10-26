
import Foundation
import PromiseKit

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
                RealmManager.setDefaultRealmConfiguration(with: syncUser)
                let user = RealmManager.createNewUser(syncUser: syncUser, request.name!, request.email)
                let response = Login.Response(user: user)
                self?.presenter?.presentNewUserMessage(response: response)
            }
            .catch { [weak self] (error) -> Void in
                let response = Login.Response(user: nil)
                self?.presenter?.presentNewUserMessage(response: response)
        }
    }
    
    func loginUser(request: Login.Request) {
        print("\(request.email), \(request.password)")
        RealmManager
            .login(email: request.email, password: request.password)
            .then { (syncUser) -> Promise<User> in
                RealmManager.setDefaultRealmConfiguration(with: syncUser)
                return RealmManager.loadExistingUser(with: syncUser)
            }
            .then { [weak self] (user) -> Void in
                let response = Login.Response(user: user)
                self?.presenter?.presentExistingUserMessage(response: response)
            }
            .catch { [weak self] (error) -> Void in
                print(error.localizedDescription)
                let response = Login.Response(user: nil)
                self?.presenter?.presentExistingUserMessage(response: response)
        }
    }
    
}
