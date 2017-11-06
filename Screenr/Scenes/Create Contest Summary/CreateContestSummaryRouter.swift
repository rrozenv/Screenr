
import Foundation
import UIKit

@objc protocol CreateContestSummaryRoutingLogic {
    func routeToMainMovieList()
}

class CreateContestSummaryRouter: NSObject, CreateContestSummaryRoutingLogic {
    
    weak var viewController: CreateContestSummaryViewController?
    
    // MARK: Routing
    func routeToMainMovieList() {
        navigateToMainMovieList(source: viewController!)
    }
    
    func navigateToMainMovieList(source: CreateContestSummaryViewController) {
        source.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
