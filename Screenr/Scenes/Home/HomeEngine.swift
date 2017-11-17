
import Foundation
import CoreLocation

protocol HomeBusinessLogic {
    func fetchCurrentLocation()
}

final class HomeEngine: HomeBusinessLogic, LocationServiceDelegate {
    
    lazy var privateRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.secret)
    }()
    
    func fetchCurrentLocation() {
        //tracingLocation(currentLocation:) will be called after inital location is found
        LocationService.shared.delegate = self
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        fetchPostalCode(for: currentLocation)
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        if let lastLocation = LocationService.shared.lastLocation {
            fetchPostalCode(for: lastLocation)
        }
        print("Fetching location failed: \(error.localizedDescription)")
    }
    
    func fetchPostalCode(for location: CLLocation) {
        LocationService.shared
            .fetchPostalCodeFor(location)
            .then { [weak self] (postalCode) -> Void in
                guard let postalCode = postalCode else { return }
                self?.saveCurrentLocationToDefaults(postalCode)
                self?.saveLocationInDatabase(postalCode)
                NotificationCenter.default.post(name: .locationChanged, object: nil)
                print("Fetched zip: \(String(describing: postalCode))")
            }
            .catch { (error) in
                print(error.localizedDescription)
        }
    }
    
}

extension HomeEngine {
    
    fileprivate func saveCurrentLocationToDefaults(_ location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
    fileprivate func saveLocationInDatabase(_ location: String) {
        //Check if location is already saved first
        let predicate = NSPredicate(format: "code == %@", "\(location)")
        self.privateRealm
            .fetch(Location_R.self, predicate: predicate, sorted: nil)
            .then { [weak self] (locations) -> Void in
                if locations.count < 1 {
                    self?.createNewLocation(location)
                }
            }
            .catch { (error) in
                print(error.localizedDescription)
        }
    }
    
    fileprivate func createNewLocation(_ location: String) {
        let value = ["code": location]
        self.privateRealm
            .create(Location_R.self, value: value)
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
    }
    
}
