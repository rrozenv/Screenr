
import Foundation
import RealmSwift

protocol LocationSearchLogic {
    func fetchSavedLocations()
}

protocol LocationSearchDataStore {
    var locations: [Location_R] { get set }
}

final class LocationSearchEngine: LocationSearchLogic {
    
    var presenter: LocationSearchPresentationLogic?
    
    func fetchSavedLocations() {
        let realm = try! Realm(configuration: RealmConfig.secret.configuration)
        let savedLocations = realm.objects(Location_R.self)
        var response: LocationSearch.Response
        if savedLocations.count >= 1 {
            response = LocationSearch.Response(locations: Array(savedLocations))
        } else {
            response = LocationSearch.Response(locations: [Location_R]())
        }
        presenter?.presentSavedLocations(response: response)
    }
    
}
