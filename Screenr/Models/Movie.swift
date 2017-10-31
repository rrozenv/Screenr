
import Foundation
import RealmSwift

class Movie_R: Object {
    dynamic var uniqueID: String = UUID().uuidString
    dynamic var movieID: String = "0"
    dynamic var title: String = ""
    let theatres = List<Theatre_R>()
    let showtimes = List<Showtime_R>()
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
    
    convenience init?(dictionary: JSONDictionary) {
        self.init()
        guard let id = dictionary["rootId"] as? String,
            let title = dictionary["title"] as? String else { return nil }
        self.movieID = id
        self.title = title
        
        guard let showtimesArray = dictionary["showtimes"] as? [JSONDictionary] else { return }
        
        for showtime in showtimesArray {
            if let theatreDict = showtime["theatre"] as? JSONDictionary,
                let time = showtime["dateTime"] as? String {
                let theatre = Theatre_R(dictionary: theatreDict)
                let showTime = Showtime_R(theatreID: theatre.theatreID, movieID: self.movieID, time: time)
                showtimes.append(showTime)
                if let _ = theatres.index(where: { $0.theatreID == theatre.theatreID }) { continue }
                theatres.append(theatre)
            } else {
                continue
            }
        }
    }
    
}

extension Movie_R {
    
    class func resource(for location: String?) -> Resource<[Movie_R]> {
        return Resource<[Movie_R]>(target: .currentMovies(location: location ?? "")) { json in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap(Movie_R.init)
        }
    }
    
}

extension Movie_R {
    
    func getShowtimesFor(theatreID: String) -> [Showtime_R] {
        return Array(self.showtimes).filter { $0.theatreID == theatreID }
    }
    
}







