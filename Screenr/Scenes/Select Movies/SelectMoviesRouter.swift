
import Foundation
import UIKit

@objc protocol SelectMoviesRoutingLogic {
    func routeToSelectTheatre()
}

class SelectMoviesRouter: NSObject, SelectMoviesRoutingLogic {
    
    weak var viewController: SelectMoviesViewController?
    
    // MARK: Routing
    func routeToSelectTheatre(){
        let destinationVC = MovieSearchViewController()
        navigateToMainMovieList(source: viewController!, destination: destinationVC)
    }
    
    func navigateToMainMovieList(source: SelectMoviesViewController, destination: MovieSearchViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
}
