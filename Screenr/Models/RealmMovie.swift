
import Foundation
import RealmSwift

class Movie: Object {
    dynamic var id: String = "0"
    dynamic var title: String = ""
    let theatres = List<Theatre>()
    let showtimes = List<Showtime>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init?(dictionary: JSONDictionary) {
        self.init()
        guard let id = dictionary["rootId"] as? String,
            let title = dictionary["title"] as? String else { return nil }
        self.id = id
        self.title = title
        
        guard let showtimesArray = dictionary["showtimes"] as? [JSONDictionary] else { return }

        for showtime in showtimesArray {
            if let theatreDict = showtime["theatre"] as? JSONDictionary,
                let time = showtime["dateTime"] as? String {
                let theatre = Theatre(dictionary: theatreDict)
                let showTime = Showtime(theatreID: theatre.uniqueID, time: time)
                showtimes.append(showTime)
                if let _ = theatres.index(where: { $0.uniqueID == theatre.uniqueID }) { continue }
                theatres.append(theatre)
            } else {
                continue
            }
        }
    }
    
}

extension Movie {
    
    func getShowtimesFor(theatreID: String) -> [Showtime] {
        return Array(self.showtimes).filter { $0.uniqueID == theatreID }
    }

}

class Showtime: Object {
    dynamic var uniqueID: String = "0"
    dynamic var theatreID: String = UUID().uuidString
    dynamic var time: String = ""
    
    override static func primaryKey() -> String? {
        return "theatreID"
    }
    
    convenience init(theatreID: String, time: String) {
        self.init()
        self.uniqueID = theatreID
        self.time = time
    }
}

extension Showtime {
    
    var formattedShowTime: Showtime? {
        if let date = self.time.convertToDate {
            let time = date.timeOnlyString
            let showtime = Showtime(theatreID: self.uniqueID, time: time)
            return showtime
        } else {
            return nil
        }
    }
    
}

class Theatre: Object {
    dynamic var uniqueID: String = "0"
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(dictionary: JSONDictionary) {
        self.init()
        self.uniqueID = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
    }
}

//    func getUniqueTheatres() -> [Theatre]? {
//        return uniqueElementsFrom(array: self.theatres!)
//    }
//
//    func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
//        var set = Set<T>()
//        let result = array.filter {
//            guard !set.contains($0) else {
//                return false
//            }
//            set.insert($0)
//            return true
//        }
//        return result
//    }


