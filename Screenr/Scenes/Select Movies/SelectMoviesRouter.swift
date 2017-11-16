
import Foundation
import UIKit

@objc protocol SelectMoviesRoutingLogic {
    func routeToSelectTheatre()
    func routeToHome()
}

class SelectMoviesRouter: NSObject, SelectMoviesRoutingLogic {
    
    weak var viewController: SelectMoviesViewController?
    
    // MARK: Routing
    func routeToSelectTheatre(){
        let destinationVC = SelectTheatreViewController()
        navigateToMainMovieList(source: viewController!, destination: destinationVC)
    }
    
    func routeToHome() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func navigateToMainMovieList(source: SelectMoviesViewController, destination: SelectTheatreViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    
    
    
}
