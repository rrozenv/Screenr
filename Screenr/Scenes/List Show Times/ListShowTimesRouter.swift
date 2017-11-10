
import Foundation

@objc protocol ListShowtimesRoutingLogic {
    func routeToHome()
}

protocol ListShowtimesDataPassing {
    var dataStore: ListShowtimesDataStore? { get }
}

class ListShowtimesRouter: NSObject, ListShowtimesDataPassing, ListShowtimesRoutingLogic {
    weak var viewController: ListShowTimesViewController?
    var dataStore: ListShowtimesDataStore?
    
    // MARK: Routing
    func routeToHome() {
        let index = viewController!.navigationController!.viewControllers.count - 2
        let destinationVC = viewController?.navigationController?.viewControllers[index] as! HomeViewController
        navigateToHome(source: viewController!, destination: destinationVC)
    }
    
    func navigateToHome(source: ListShowTimesViewController, destination: HomeViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
}

