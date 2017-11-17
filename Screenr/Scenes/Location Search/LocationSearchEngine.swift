
import Foundation
import RealmSwift

protocol LocationSearchLogic {
    func fetchSavedLocations()
    func fetchLocationFromSavedLocations(request: LocationSearch.SaveLocation.Request)
    func processNewLocation(request: LocationSearch.SaveLocation.Request)
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
    
    func fetchLocationFromSavedLocations(request: LocationSearch.SaveLocation.Request) {
        if let index = locations.index(where: { $0.code == request.zipCode }) {
            self.saveCurrentLocationToDefaults(location: locations[index].code)
            let response = LocationSearch.SaveLocation.Response(location: locations[index])
            presenter?.presentConfirmation(response: response)
        } else {
            print("Location not found in history.")
        }
    }
    
    func processNewLocation(request: LocationSearch.SaveLocation.Request) {
        guard isValidLocation(request.zipCode) else {
            self.presenter?.presentInvalidLocationEntry()
            return
        }
        self.saveCurrentLocationToDefaults(location: request.zipCode)
        self.saveLocationToDatabase(location: request.zipCode) { [weak self] (newLocation) in
            let response = LocationSearch.SaveLocation.Response(location: newLocation!)
            self?.presenter?.presentConfirmation(response: response)
        }
    }
    
}

extension LocationSearchEngine {
    
    fileprivate func isValidLocation(_ location: String) -> Bool {
        return location.count == 5
    }
    
    fileprivate func saveCurrentLocationToDefaults(location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
    fileprivate func saveLocationToDatabase(location: String, completion: @escaping (Location_R?) -> Void) {
        let value = ["code": location]
        //let backgroundQ = DispatchQueue.global(qos: .background)
        privateRealm
            .create(Location_R.self, value: value)
            .then { (newLocation) -> Void in
                print("Location: \(newLocation.code) saved successfully")
                completion(newLocation)
            }
            .catch { (error) in
                completion(nil)
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
    }
    
}
