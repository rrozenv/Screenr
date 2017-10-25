
import Foundation

protocol ListShowtimesDataPassing {
    var dataStore: ListShowtimesDataStore? { get }
}

class ListShowtimesRouter: NSObject, ListShowtimesDataPassing {
    weak var viewController: ListShowTimesViewController?
    var dataStore: ListShowtimesDataStore?
    
    // MARK: Routing
    
}

