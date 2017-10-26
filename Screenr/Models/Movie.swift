
import Foundation


//struct Movie {
//    let id: String
//    let title: String
//    let theatres: [Theatre]?
//    let showtimes: [Showtime]?
//}
//
//extension Movie {
//    init?(dictionary: JSONDictionary) {
//        guard let id = dictionary["rootId"] as? String,
//            let title = dictionary["title"] as? String else { return nil }
//        self.id = id
//        self.title = title
//        
//        guard let showtimesArray = dictionary["showtimes"] as? [JSONDictionary] else {
//            self.theatres = nil
//            self.showtimes = nil
//            return
//        }
//        
//        var theatres = [Theatre]()
//        var showtimes = [Showtime]()
//        
//        for showtime in showtimesArray {
//            if let theatreDict = showtime["theatre"] as? JSONDictionary,
//                let time = showtime["dateTime"] as? String {
//                let theatre = Theatre(dictionary: theatreDict)
//                let showTime = Showtime(theatreID: theatre.id, time: time)
//                theatres.append(theatre)
//                showtimes.append(showTime)
//            } else {
//                continue
//            }
//        }
//        
//        self.theatres = theatres
//        self.showtimes = showtimes
//    }
//}
//
//extension Movie {
//    
//    func getShowtimesFor(theatreID: String) -> [Showtime]? {
//        guard let showtimes = self.showtimes else { return nil }
//        let filteredShowtimes = showtimes.filter { $0.theatreID == theatreID }
//        return filteredShowtimes
//    }
//    
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
//    
//}
//
//struct Showtime {
//    let theatreID: String
//    let time: String
//}
//
//extension Showtime {
//    
//    var formattedShowTime: Showtime? {
//        if let date = self.time.convertToDate {
//            let time = date.timeOnlyString
//            let showtime = Showtime(theatreID: self.theatreID, time: time)
//            return showtime
//        } else {
//            return nil
//        }
//    }
//    
//}
//
//struct Theatre: Hashable, Equatable {
//    let id: String
//    let name: String
//    
//    var hashValue: Int {
//        return id.hashValue
//    }
//    
//    static func ==(lhs: Theatre, rhs: Theatre) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
//
//extension Theatre {
//    init(dictionary: JSONDictionary) {
//        self.id = dictionary["id"] as? String ?? ""
//        self.name = dictionary["name"] as? String ?? ""
//    }
//}





