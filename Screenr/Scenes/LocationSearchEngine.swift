
import Foundation
import RealmSwift

protocol LocationSearchLogic {
    func fetchSavedLocations()
    func saveLocationToDatabase(request: LocationSearch.SaveLocation.Request)
}

protocol LocationSearchDataStore {
    var locations: [Location_R]! { get set }
    var currentlySelectedLocation: Location_R! { get set }
}

final class LocationSearchEngine: LocationSearchLogic, LocationSearchDataStore {
    
    var presenter: LocationSearchPresentationLogic?
    var locations: [Location_R]!
    var currentlySelectedLocation: Location_R!
    
    func fetchSavedLocations() {
        let realm = try! Realm(configuration: RealmConfig.secret.configuration)
        let savedLocations = realm.objects(Location_R.self)
        var response: LocationSearch.Response
        if savedLocations.count >= 1 {
            self.locations = Array(savedLocations)
            response = LocationSearch.Response(locations: Array(savedLocations))
        } else {
            self.locations = [Location_R]()
            response = LocationSearch.Response(locations: [Location_R]())
        }
        presenter?.presentSavedLocations(response: response)
    }
    
    func saveLocationToDatabase(request: LocationSearch.SaveLocation.Request) {
        //guard let locations = locations else { return }
        if let index = locations.index(where: { $0.code == request.zipCode }) {
            self.currentlySelectedLocation = locations[index]
            let response = LocationSearch.SaveLocation.Response(location: locations[index])
            presenter?.presentConfirmation(response: response)
        } else {
            let realm = try! Realm(configuration: RealmConfig.secret.configuration)
            let location = Location_R(zipCode: request.zipCode, name: nil)
            RealmManager.addObject(location, primaryKey: location.uniqueID, config: RealmConfig.secret)
            //realm.add(locations[index!])
            self.currentlySelectedLocation = location
            let response = LocationSearch.SaveLocation.Response(location: location)
            presenter?.presentConfirmation(response: response)
        }
    }
    
}
