
import Foundation
import UIKit

@objc protocol SelectMoviesRoutingLogic {
    func routeToSelectTheatre()
}

class SelectMoviesRouter: NSObject, SelectMoviesRoutingLogic {
    
    weak var viewController: SelectMoviesViewController?
    
    // MARK: Routing
    func routeToSelectTheatre(){
        let destinationVC = SelectTheatreViewController()
        navigateToMainMovieList(source: viewController!, destination: destinationVC)
    }
    
    func navigateToMainMovieList(source: SelectMoviesViewController, destination: SelectTheatreViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
}
