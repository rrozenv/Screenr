
import UIKit

@objc protocol MainMovieListRoutingLogic {
    func routeToShowMovieShowtimes(for selectedMovie: Movie_R)
    func routeToSettings()
    func routeToLocationSearch()
    func routeToMovieSearch()
}

protocol MainMovieListDataPassing {
  var dataStore: MainMovieListDataStore? { get }
}

class MainMovieListRouter: NSObject, MainMovieListRoutingLogic, MainMovieListDataPassing {
    
    weak var viewController: MainMovieListViewController?
    var dataStore: MainMovieListDataStore?
  
  // MARK: Routing
    func routeToShowMovieShowtimes(for selectedMovie: Movie_R) {
        let destinationVC = ListShowTimesViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToListShowtimes(selectedMovie: selectedMovie, destination: &destinationDS)
        //passDataToListShowtimes(source: dataStore!, destination: &destinationDS)
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
    
    func routeToMovieSearch() {
        let destinationVC = SelectMoviesViewController()
        navigateToMovieSearch(source: viewController!, destination: destinationVC)
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
    
    func navigateToMovieSearch(source: MainMovieListViewController, destination: SelectMoviesViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
  
  // MARK: Passing data
  
  func passDataToListShowtimes(selectedMovie: Movie_R, destination: inout ListShowtimesDataStore) {
    //let selectedRow = viewController?.collectionView.indexPathsForSelectedItems?.first
    //destination.movie = source.movies?[(selectedRow?.row)!]
    destination.movie = selectedMovie
  }
    
}
