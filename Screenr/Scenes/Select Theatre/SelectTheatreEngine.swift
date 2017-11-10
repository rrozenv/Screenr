
import Foundation

protocol SelectTheatreLogic {
    func saveSelectedTheatreToDataStore(_ theatre: Theatre_R)
    func saveSelectedTheatreToDatabase()
}

protocol SelectTheatreDataStore {
    var selectedTheatre: Theatre_R? { get set }
}

final class SelectTheatreEngine: SelectTheatreLogic, SelectTheatreDataStore {
    
    var selectedTheatre: Theatre_R?
    lazy var temporaryRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.temporary)
    }()
    
    func saveSelectedTheatreToDataStore(_ theatre: Theatre_R) {
        self.selectedTheatre = theatre
    }
    
    func saveSelectedTheatreToDatabase() {
        guard let theatre = selectedTheatre else { return }
        self.temporaryRealm
            .save(object: theatre)
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
            }
    }
    
}
