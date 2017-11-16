
import Foundation
import UIKit

@objc protocol SelectTheatreRoutingLogic {
    func routeToCreateContestSummary()
    func routeToSelectMovies()
}

class SelectTheatreRouter: NSObject, SelectTheatreRoutingLogic {
    
    weak var viewController: SelectTheatreViewController?
    
    // MARK: Routing
    func routeToCreateContestSummary() {
        let destinationVC = CreateContestSummaryViewController()
        navigateToMainMovieList(source: viewController!, destination: destinationVC)
    }
    
    func routeToSelectMovies() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMainMovieList(source: SelectTheatreViewController, destination: CreateContestSummaryViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    
}
