
import Foundation
import UIKit

@objc protocol LocationSearchRoutingLogic {
    func routeToMainMovieList()
}

protocol LocationSearchDataPassing {
    var dataStore: LocationSearchDataStore? { get }
}

class LocationSearchRouter: NSObject, LocationSearchRoutingLogic, LocationSearchDataPassing {
    
    weak var viewController: LocationSearchViewController?
    var dataStore: LocationSearchDataStore?
    
    // MARK: Routing
    func routeToMainMovieList() {
        let index = viewController!.navigationController!.viewControllers.count - 2
        let destinationVC = viewController?.navigationController?.viewControllers[index] as! MainMovieListViewController
        //var destinationDS = destinationVC.router!.dataStore!
        //passDataToMainMovieList(source: dataStore!, destination: &destinationDS)
        navigateToMainMovieList(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Passing data
    
    func passDataToMainMovieList(source: LocationSearchDataStore, destination: inout MainMovieListDataStore) {
        
    }
    
    func navigateToMainMovieList(source: LocationSearchViewController, destination: MainMovieListViewController) {
        destination.locationDidChange = true
        source.navigationController?.popViewController(animated: true)
    }

}
