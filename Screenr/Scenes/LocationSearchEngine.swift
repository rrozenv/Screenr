
import Foundation
import RealmSwift

protocol LocationSearchLogic {
    func fetchSavedLocations()
    func saveLocationToDatabase(request: LocationSearch.SaveLocation.Request)
}

protocol LocationSearchDataStore {
    var locations: [Location_R]! { get set }
    var currentlySelectedLocation: Location_R? { get set }
}

final class LocationSearchEngine: LocationSearchLogic, LocationSearchDataStore {
    
    var presenter: LocationSearchPresentationLogic?
    var locations: [Location_R]!
    var currentlySelectedLocation: Location_R?
    
    func fetchSavedLocations() {
        let realm = try! Realm(configuration: RealmConfig.secret.configuration)
        let savedLocations = realm.objects(Location_R.self)
        var response: LocationSearch.Response
        if savedLocations.count >= 1 {
            self.locations = Array(savedLocations)
            response = LocationSearch.Response(locations: self.locations)
        } else {
            self.locations = [Location_R]()
            response = LocationSearch.Response(locations: self.locations)
        }
        presenter?.presentSavedLocations(response: response)
    }
    
    func saveLocationToDatabase(request: LocationSearch.SaveLocation.Request) {
        UserDefaults.standard.set(request.zipCode, forKey: "usersLocation")
        if let index = locations.index(where: { $0.code == request.zipCode }) {
            self.currentlySelectedLocation = locations[index]
            let response = LocationSearch.SaveLocation.Response(location: locations[index])
            presenter?.presentConfirmation(response: response)
        } else {
            let location = Location_R(zipCode: request.zipCode, name: nil)
            location.isCurrentlySelected = true
            RealmManager.addObject(location, primaryKey: location.uniqueID, config: RealmConfig.secret)
            self.currentlySelectedLocation = location
            let response = LocationSearch.SaveLocation.Response(location: location)
            presenter?.presentConfirmation(response: response)
        }
    }
    
}
