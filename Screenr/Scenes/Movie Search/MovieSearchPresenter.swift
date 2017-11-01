
import Foundation

protocol MovieSearchPresentationLogic {
    func formatMovies(response: MoviesSearch.Response)
}

class MovieSearchPresenter: MovieSearchPresentationLogic {
    
    weak var viewController: MovieSearchViewController?
    
    func formatMovies(response: MoviesSearch.Response) {
//        let displayedLocations = response.locations.map({ (location) -> LocationSearch.DisplayedLocation in
//            return LocationSearch.DisplayedLocation(zipCode: location.code)
//        })
//        let viewModel = LocationSearch.ViewModel(displayedLocations: displayedLocations)
//        viewController?.displaySavedLocations(viewModel: viewModel)
    }
    
}
