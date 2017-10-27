
import Foundation
import RealmSwift

class Showtime_R: Object {
    dynamic var uniqueID: String = UUID().uuidString
    dynamic var theatreID: String = ""
    dynamic var movieID: String = ""
    dynamic var time: String = ""
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
    
    convenience init(theatreID: String, movieID: String, time: String) {
        self.init()
        self.theatreID = theatreID
        self.movieID = movieID
        self.time = time
    }
}

extension Showtime_R {
    
    var formattedShowTime: Showtime_R? {
        if let date = self.time.convertToDate {
            let time = date.timeOnlyString
            let showtime = Showtime_R(theatreID: self.theatreID, movieID: self.movieID, time: time)
            return showtime
        } else {
            return nil
        }
    }
    
}
