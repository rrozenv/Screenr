
import Foundation
import RealmSwift

final class Theatre_R: Object {
    dynamic var uniqueID: String = UUID().uuidString
    dynamic var theatreID: String = ""
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
    
    convenience init(dictionary: JSONDictionary) {
        self.init()
        self.theatreID = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
    }
    
    convenience init(theatreID: String, name: String) {
        self.init()
        self.theatreID = theatreID
        self.name = name
    }
}
