
import Foundation
import UIKit

@objc protocol HomeRoutingLogic {
    func routeToSettings()
    func routeToLocationSearch()
    //func routeToMovieSearch()
}

class HomeRouter: NSObject, HomeRoutingLogic {
    
    weak var viewController: HomeViewController?
    
    // MARK: Routing
    func routeToSettings() {
        let destinationVC = SettingsViewController()
        navigateToSettings(source: viewController!, destination: destinationVC)
    }
    
    func routeToLocationSearch() {
        let destinationVC = LocationSearchViewController()
        navigateToLocationSearch(source: viewController!, destination: destinationVC)
    }
    
//    func routeToMovieSearch() {
//        let rootController = SelectMoviesViewController()
//        let destinationVC = UINavigationController(rootViewController: rootController)
//        navigateToMovieSearch(source: viewController!, destination: destinationVC)
//    }
//    
    // MARK: Navigation
    
    func navigateToSettings(source: HomeViewController, destination: SettingsViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToLocationSearch(source: HomeViewController, destination: LocationSearchViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
//    func navigateToMovieSearch(source: MainMovieListViewController, destination: UINavigationController) {
//        source.present(destination, animated: true, completion: nil)
//    }
    
}
