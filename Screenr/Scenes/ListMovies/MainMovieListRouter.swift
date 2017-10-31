
import UIKit

@objc protocol MainMovieListRoutingLogic {
    func routeToShowMovieShowtimes()
    func routeToSettings()
    func routeToLocationSearch()
}

protocol MainMovieListDataPassing {
  var dataStore: MainMovieListDataStore? { get }
}

class MainMovieListRouter: NSObject, MainMovieListRoutingLogic, MainMovieListDataPassing {
    
    weak var viewController: MainMovieListViewController?
    var dataStore: MainMovieListDataStore?
  
  // MARK: Routing
    func routeToShowMovieShowtimes() {
        let destinationVC = ListShowTimesViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToListShowtimes(source: dataStore!, destination: &destinationDS)
        navigateToListShowtimes(source: viewController!, destination: destinationVC)
    }
    
    func routeToSettings() {
        let destinationVC = SettingsViewController()
        navigateToSettings(source: viewController!, destination: destinationVC)
    }
    
    func routeToLocationSearch() {
        let destinationVC = LocationSearchViewController()
        navigateToLocationSearch(source: viewController!, destination: destinationVC)
    }
  
  // MARK: Navigation
  
  func navigateToListShowtimes(source: MainMovieListViewController, destination: ListShowTimesViewController) {
     source.navigationController?.pushViewController(destination, animated: true)
  }
    
    func navigateToSettings(source: MainMovieListViewController, destination: SettingsViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToLocationSearch(source: MainMovieListViewController, destination: LocationSearchViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
  
  // MARK: Passing data
  
  func passDataToListShowtimes(source: MainMovieListDataStore, destination: inout ListShowtimesDataStore) {
    let selectedRow = viewController?.collectionView.indexPathsForSelectedItems?.first
    destination.movie = source.movies?[(selectedRow?.row)!]
  }
    
}
