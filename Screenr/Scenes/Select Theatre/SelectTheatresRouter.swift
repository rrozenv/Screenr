
import Foundation
import UIKit

@objc protocol SelectTheatreRoutingLogic {
    func routeToCreateContestSummary()
}

class SelectTheatreRouter: NSObject, SelectTheatreRoutingLogic {
    
    weak var viewController: SelectTheatreViewController?
    
    // MARK: Routing
    func routeToCreateContestSummary() {
        let destinationVC = MovieSearchViewController(searchType: .theatres)
        navigateToMainMovieList(source: viewController!, destination: destinationVC)
    }
    
    func navigateToMainMovieList(source: SelectTheatreViewController, destination: MovieSearchViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
}
