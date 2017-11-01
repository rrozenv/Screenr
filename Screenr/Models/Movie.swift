
import Foundation
import RealmSwift

class Movie_R: Object {
    dynamic var uniqueID: String = UUID().uuidString
    dynamic var movieID: String = "0"
    dynamic var title: String = ""
    dynamic var posterURL: String = ""
    dynamic var year: String = ""
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
    
    convenience init?(OMDBdictionary: JSONDictionary) {
        self.init()
        guard let id = OMDBdictionary["rootId"] as? String,
            let title = OMDBdictionary["title"] as? String else { return nil }
        self.movieID = id
        self.title = title
        
        if let posterUrl = OMDBdictionary["Poster"] as? String {
            self.posterURL = posterUrl
        }
        
        if let year = OMDBdictionary["Year"] as? String {
            self.year = year
        }
    }
    
}

extension Movie_R {
    
    class func OMDBmoviesResource(for query: String) -> Resource<[Movie_R]> {
        return Resource<[Movie_R]>(target: OMDbAPI.search(query: query)) { (json: Any) -> [Movie_R]? in
            guard let searchDictionary = json as? [String: Any] else { return nil }
            guard let dictionaries = searchDictionary["Search"] as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap({ (dictionary) -> Movie_R? in
                return Movie_R(OMDBdictionary: dictionary)
            })
        }
    }
    
    class func moviesResource(for location: String?) -> Resource<[Movie_R]> {
        return Resource<[Movie_R]>(target: ServerAPI.currentMovies(location: location ?? "")) { json in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap({ (dictionary) -> Movie_R? in
                return Movie_R(dictionary: dictionary)
            })
        }
    }
    
    class func showtimesResource(location: String, date: String, movieId: String) -> Resource<Movie_R> {
        return Resource<Movie_R>(target: ServerAPI.movieShowtimes(id: movieId, date: date, location: location)) { json in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            let movies = dictionaries.flatMap({ (dictionary) -> Movie_R? in
                return Movie_R(dictionary: dictionary)
            })
            return movies.first
        }
    }
    
}

extension Movie_R {
    
    func getShowtimesFor(theatreID: String) -> [Showtime_R] {
        return Array(self.showtimes).filter { $0.theatreID == theatreID }
    }
    
}







