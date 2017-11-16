
import Foundation
import UIKit

@objc protocol CreateContestSummaryRoutingLogic {
    func routeToMainMovieList()
    func routeToSelectTheatre()
}

class CreateContestSummaryRouter: NSObject, CreateContestSummaryRoutingLogic {
    
    weak var viewController: CreateContestSummaryViewController?
    
    // MARK: Routing
    func routeToMainMovieList() {
        navigateToMainMovieList(source: viewController!)
    }
    
    func routeToSelectTheatre() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func navigateToMainMovieList(source: CreateContestSummaryViewController) {
        source.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
