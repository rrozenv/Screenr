
import Foundation
import RealmSwift

class Contest_R: Object {
    dynamic var uniqueID: String = UUID().uuidString
    dynamic var theatre: Theatre_R?
    dynamic var calendarDate = Date()
    dynamic var ticketPrice: String = ""
    dynamic var votesRequired: String = ""
    //dynamic var time = Date()
    let movies = List<ContestMovie_R>()
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
    
    convenience init(theatre: Theatre_R?, calendarDate: Date, movies: [ContestMovie_R], ticketPrice: String, votesRequired: String) {
        self.init()
        self.theatre = theatre
        self.calendarDate = calendarDate
        self.ticketPrice = ticketPrice
        self.votesRequired = votesRequired
        for movie in movies {
            self.movies.append(movie)
        }
    }
    
}

class ContestMovie_R: Object {
    dynamic var uniqueID: String = UUID().uuidString
    dynamic var movieID: String = "0"
    dynamic var title: String = ""
    dynamic var posterURL: String = ""
    dynamic var year: String = ""
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
    
    convenience init?(OMDBdictionary: JSONDictionary) {
        self.init()
        guard let id = OMDBdictionary["imdbID"] as? String,
            let title = OMDBdictionary["Title"] as? String else { return nil }
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

extension ContestMovie_R {
    
    class func OMDBmoviesResource(for query: String) -> Resource<[ContestMovie_R]> {
        return Resource<[ContestMovie_R]>(target: OMDbAPI.search(query: query)) { (json) -> [ContestMovie_R]? in
            guard let searchDictionary = json as? [String: Any] else { return nil }
            guard let dictionaries = searchDictionary["Search"] as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap({ (dictionary) -> ContestMovie_R? in
                return ContestMovie_R(OMDBdictionary: dictionary)
            })
        }
    }
    
}
