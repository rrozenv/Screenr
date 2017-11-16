
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
                self?.locations = locations.isEmpty ? [Location_R]() : locations
                let response = LocationSearch.Response(locations: locations)
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
    
}

extension LocationSearchEngine {
    
    fileprivate func saveCurrentLocationToDefaults(location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
    fileprivate func saveLocationToDatabase(location: String) {
        let value = ["code": location]
        //let backgroundQ = DispatchQueue.global(qos: .background)
        privateRealm
            .create(Location_R.self, value: value)
            .then { [weak self] (newLocation) -> Void in
                let response = LocationSearch.SaveLocation.Response(location: newLocation)
                self?.presenter?.presentConfirmation(response: response)
            }
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
    }
    
}
