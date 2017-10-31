
import Foundation
import RealmSwift

protocol LocationSearchLogic {
    func fetchSavedLocations()
    func didSelectLocation(request: LocationSearch.SaveLocation.Request)
}

protocol LocationSearchDataStore {
    var locations: [Location_R]! { get set }
    var currentlySelectedLocation: Location_R? { get set }
}

final class LocationSearchEngine: LocationSearchLogic, LocationSearchDataStore {
    
    var presenter: LocationSearchPresentationLogic?
    var locations: [Location_R]!
    var currentlySelectedLocation: Location_R?
    
    lazy var privateRealm: RealmStorageContext = {
       return RealmStorageContext(configuration: RealmConfig.secret)
    }()
    
    func fetchSavedLocations() {
        privateRealm
            .fetch(Location_R.self)
            .then { [weak self] (locations) -> Void in
                var response: LocationSearch.Response
                if locations.count >= 1 {
                    self?.locations = locations
                    response = LocationSearch.Response(locations: locations)
                } else {
                    self?.locations = [Location_R]()
                    response = LocationSearch.Response(locations: locations)
                }
                self?.presenter?.presentSavedLocations(response: response)
            }
            .catch { (error) in
                print(error.localizedDescription)
            }
    }
    
    func didSelectLocation(request: LocationSearch.SaveLocation.Request) {
        self.saveCurrentLocationToDefaults(location: request.zipCode)
        if let index = locations.index(where: { $0.code == request.zipCode }) {
            let response = LocationSearch.SaveLocation.Response(location: locations[index])
            presenter?.presentConfirmation(response: response)
        } else {
            self.saveLocationToDatabase(location: request.zipCode)
        }
    }
    
    private func saveCurrentLocationToDefaults(location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
    private func saveLocationToDatabase(location: String) {
        let value = ["code": location]
        //let backgroundQ = DispatchQueue.global(qos: .background)
        privateRealm
            .create(Location_R.self, value: value)
            .then { newLocation -> Void in
                let response = LocationSearch.SaveLocation.Response(location: newLocation)
                self.presenter?.presentConfirmation(response: response)
            }
            .catch { (error) in
                print(error.localizedDescription)
            }
    }
    
}
