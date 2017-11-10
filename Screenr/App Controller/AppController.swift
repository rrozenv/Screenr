
import UIKit
import RxSwift
import RealmSwift

enum UserState {
    case loggedIn(SyncUser)
    case loggedOut
    
    static var currentState: UserState {
        if let syncUser = RealmLoginManager.isUserLoggedIn() {
            return .loggedIn(syncUser)
        }
        return .loggedOut
    }
}

final class AppController: UIViewController {
    
    fileprivate var actingVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
        loadInitialViewController()
    }
    
}

// MARK: - Notficiation Observers
extension AppController {
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeLoginVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .closeOnboardingVC, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .logout, object: nil)
    }
    
}

// MARK: - Loading VC's
extension AppController {
    
    func loadInitialViewController() {
        switch UserState.currentState {
        case .loggedIn(_):
            Realm.Configuration.defaultConfiguration = RealmConfig.common.configuration
            self.actingVC = UINavigationController(rootViewController: HomeViewController(currentTabButton: .mainMovieList))
        case .loggedOut:
            self.actingVC = LoginViewController()
        }
        self.add(viewController: self.actingVC, animated: true)
    }
    
}

// MARK: - Displaying VC's
extension AppController {
    
    func add(viewController: UIViewController, animated: Bool = false) {
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        view.alpha = 0.0
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
        
        guard animated else { view.alpha = 1.0; return }
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.view.alpha = 1.0
        }) { _ in }
    }
    
    @objc func switchViewController(with notification: Notification) {
        switch notification.name {
        case Notification.Name.closeLoginVC:
            let mainMovieListVC = UINavigationController(rootViewController: HomeViewController(currentTabButton: .mainMovieList))
            switchToViewController(mainMovieListVC)
        case Notification.Name.closeOnboardingVC:
            let masterTabBarVC = UINavigationController(rootViewController: UIViewController())
            switchToViewController(masterTabBarVC)
        case Notification.Name.logout:
            let loginVC = LoginViewController()
            switchToViewController(loginVC)
        default:
            fatalError("\(#function) - Unable to match notficiation name.")
        }
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        let existingVC = actingVC
        existingVC?.willMove(toParentViewController: nil)
        add(viewController: viewController)
        actingVC.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, animations: {
            self.actingVC.view.alpha = 1.0
            existingVC?.view.alpha = 0.0
        }) { success in
            existingVC?.view.removeFromSuperview()
            existingVC?.removeFromParentViewController()
            self.actingVC.didMove(toParentViewController: self)
        }
    }
    
}

// MARK: - Notification Extension
extension Notification.Name {
    static let closeOnboardingVC = Notification.Name("close-onboarding-view-controller")
    static let closeLoginVC = Notification.Name("close-login-view-controller")
    static let logout = Notification.Name("logout")
    static let locationChanged = Notification.Name("locationChanged")
}

