
import Foundation
import RealmSwift

class Location_R: Object {
    dynamic var uniqueID: String = UUID().uuidString
    dynamic var code: String = ""
    dynamic var name: String?
    dynamic var isCurrentlySelected = false
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
    
    convenience init(zipCode: String, name: String?) {
        self.init()
        self.code = zipCode
    }
}

enum LocationSearch {
    
    struct DisplayedLocation {
        let zipCode: String
    }
    
    enum SaveLocation {
        struct Request {
            let zipCode: String
        }
        
        struct Response {
            var location: Location_R
        }
        
        struct ViewModel {
            var displayedLocation: DisplayedLocation
        }
    }
    
    //User Input -> Interactor Input
    struct Request { }
    
    //Interactor Output -> Presenter Input
    struct Response {
        var locations: [Location_R]
    }
    
    //Presenter Output -> View Controller Input
    struct ViewModel {
        var displayedLocations: [DisplayedLocation]
    }
    
}
