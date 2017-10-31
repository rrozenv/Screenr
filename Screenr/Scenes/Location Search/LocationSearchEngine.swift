
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
        privateRealm.fetch(Location_R.self) { (locations) in
            var response: LocationSearch.Response
            if locations.count >= 1 {
                self.locations = locations
                response = LocationSearch.Response(locations: self.locations)
            } else {
                self.locations = [Location_R]()
                response = LocationSearch.Response(locations: self.locations)
            }
            presenter?.presentSavedLocations(response: response)
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
        UserDefaults.standard.set(location, forKey: "usersLocation")
    }
    
    private func saveLocationToDatabase(location: String) {
        let value = ["code": location]
        privateRealm.create(Location_R.self, value: value) { (location) in
            let response = LocationSearch.SaveLocation.Response(location: location)
            self.presenter?.presentConfirmation(response: response)
        }
    }
    
}
