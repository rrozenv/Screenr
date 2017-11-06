
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
        RealmLoginManager
            .register(email: request.email, password: request.password)
            .then { [weak self] (syncUser) -> Void in
                RealmLoginManager.initializeCommonRealm(completion: { (isSuccess) in
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
        RealmLoginManager
            .login(email: request.email, password: request.password)
            .then { [weak self] (syncUser) -> Void in
                RealmLoginManager.initializeCommonRealm(completion: { (isSuccess) in
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

