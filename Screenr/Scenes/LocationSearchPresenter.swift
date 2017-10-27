
import Foundation

protocol LocationSearchPresentationLogic {
    func presentSavedLocations(response: LocationSearch.Response)
}

class LocationSearchPresenter: LocationSearchPresentationLogic {
    
    weak var viewController: LocationSearchViewController?
    
    func presentSavedLocations(response: LocationSearch.Response) {
        let displayedLocations = response.locations.map({ (location) -> LocationSearch.ViewModel.DisplayedLocation in
            return LocationSearch.ViewModel.DisplayedLocation(zipCode: location.code)
        })
        let viewModel = LocationSearch.ViewModel(displayedLocations: displayedLocations)
        viewController?.displaySavedLocations(viewModel: viewModel)
    }
    
}
