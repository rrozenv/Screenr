
import Foundation

protocol HomeBusinessLogic {
    func saveCurrentLocationToDefaults(_ location: String)
    func saveLocationInDatabase(_ location: String)
}

final class HomeEngine: HomeBusinessLogic {
    
    lazy var privateRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.secret)
    }()
    
    func saveCurrentLocationToDefaults(_ location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
    func saveLocationInDatabase(_ location: String) {
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
