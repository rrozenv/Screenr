
import Foundation
import UIKit

@objc protocol LocationSearchRoutingLogic {
    func routeToHome()
}

protocol LocationSearchDataPassing {
    var dataStore: LocationSearchDataStore? { get }
}

class LocationSearchRouter: NSObject, LocationSearchRoutingLogic, LocationSearchDataPassing {
    
    weak var viewController: LocationSearchViewController?
    var dataStore: LocationSearchDataStore?
    
    // MARK: Routing
    func routeToHome() {
        let index = viewController!.navigationController!.viewControllers.count - 2
        let destinationVC = viewController?.navigationController?.viewControllers[index] as! MasterTabBarController
        //var destinationDS = destinationVC.router!.dataStore!
        //passDataToMainMovieList(source: dataStore!, destination: &destinationDS)
        navigateToHome(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Passing data
    
    func passDataToMainMovieList(source: LocationSearchDataStore, destination: inout MainMovieListDataStore) {
        
    }
    
    func navigateToHome(source: LocationSearchViewController, destination: MasterTabBarController) {
        
        source.navigationController?.popViewController(animated: true)
    }

}
