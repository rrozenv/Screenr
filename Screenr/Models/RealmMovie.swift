
import Foundation
import RealmSwift

class RealmMovie: Object {
    dynamic var id: String = "0"
    dynamic var title: String = ""
    let theatres = List<RealmTheatre>()
    let showtimes = List<RealmShowtime>()
    
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
                let theatre = RealmTheatre(dictionary: theatreDict)
                let showTime = RealmShowtime(theatreID: theatre.id, time: time)
                showtimes.append(showTime)
                if let _ = theatres.index(of: theatre) { continue }
                theatres.append(theatre)
            } else {
                continue
            }
        }
    }
    
}

extension RealmMovie {
    
    func getShowtimesFor(theatreID: String) -> Results<RealmShowtime> {
        return self.showtimes.filter("theatreID == \(theatreID)")
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
    
}

class RealmShowtime: Object {
    dynamic var theatreID: String = "0"
    dynamic var time: String = ""
    
    override static func primaryKey() -> String? {
        return "theatreID"
    }
    
    convenience init(theatreID: String, time: String) {
        self.init()
        self.theatreID = theatreID
        self.time = time
    }
}

extension RealmShowtime {
    
    var formattedShowTime: Showtime? {
        if let date = self.time.convertToDate {
            let time = date.timeOnlyString
            let showtime = Showtime(theatreID: self.theatreID, time: time)
            return showtime
        } else {
            return nil
        }
    }
    
}

class RealmTheatre: Object {
    dynamic var id: String = "0"
    dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(dictionary: JSONDictionary) {
        self.init()
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
    }
}
