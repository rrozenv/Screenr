
import Foundation

protocol LoginPresentationLogic {
    func presentNewUserMessage(response: Login.Response)
    func presentExistingUserMessage(response: Login.Response)
}

class LoginPresenter: LoginPresentationLogic {
    weak var viewController: LoginViewController?
    
    func presentNewUserMessage(response: Login.Response) {
        if let user = response.user {
            let displayedMessage = Login.ViewModel.DisplayedMessage(header: "Welcome \(user.name)", body: "Registration Successful", isSuccess: true)
            let viewModel = Login.ViewModel(displayedMessage: displayedMessage)
            viewController?.displayMessage(viewModel: viewModel)
        } else {
            let displayedMessage = Login.ViewModel.DisplayedMessage(header: "Error", body: "Registration Unsuccessful", isSuccess: false)
            let viewModel = Login.ViewModel(displayedMessage: displayedMessage)
            viewController?.displayMessage(viewModel: viewModel)
        }
    }
    
    func presentExistingUserMessage(response: Login.Response) {
        if let user = response.user {
            let displayedMessage = Login.ViewModel.DisplayedMessage(header: "Welcome Back \(user.name)", body: "Login Successful", isSuccess: true)
            let viewModel = Login.ViewModel(displayedMessage: displayedMessage)
            viewController?.displayMessage(viewModel: viewModel)
        } else {
            let displayedMessage = Login.ViewModel.DisplayedMessage(header: "Error", body: "Login Unsuccessful", isSuccess: false)
            let viewModel = Login.ViewModel(displayedMessage: displayedMessage)
            viewController?.displayMessage(viewModel: viewModel)
        }
    }
    
}
