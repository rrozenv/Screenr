
import Foundation

protocol LocationSearchPresentationLogic {
    func presentSavedLocations(response: LocationSearch.Response)
    func presentConfirmation(response: LocationSearch.SaveLocation.Response)
    func presentInvalidLocationEntry()
}

class LocationSearchPresenter: LocationSearchPresentationLogic {
    
    weak var viewController: LocationSearchViewController?
    
    func presentSavedLocations(response: LocationSearch.Response) {
        let displayedLocations = response.locations.map({ (location) -> LocationSearch.DisplayedLocation in
            return LocationSearch.DisplayedLocation(zipCode: location.code)
        })
        let viewModel = LocationSearch.ViewModel(displayedLocations: displayedLocations)
        viewController?.displaySavedLocations(viewModel: viewModel)
    }
    
    func presentConfirmation(response: LocationSearch.SaveLocation.Response) {
        let diplaydLocation = LocationSearch.DisplayedLocation(zipCode: response.location.code)
        let viewModel = LocationSearch.SaveLocation.ViewModel(displayedLocation: diplaydLocation)
        viewController?.displayDidChangeLocationConfirmation(viewModel: viewModel)
    }
    
    func presentInvalidLocationEntry() {
        viewController?.displayInvalidLocationEntry()
    }
    
}
