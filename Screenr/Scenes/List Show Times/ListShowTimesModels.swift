
import Foundation

enum ListShowtimes {
    
    enum GetShowtimes {
        //User Input -> Interactor Input
        struct Request {
            let location: String?
            let date: String?
        }
        
        //Interactor Output -> Presenter Input
        struct Response {
            var movie: Movie
        }
        
        //Presenter Output -> View Controller Input
        struct ViewModel {
            struct DisplayedTheatre {
                let theatreID: String
                let name: String
                let movie: Movie
                let showtimes: [Showtime]?
            }
            var displayedTheaters: [DisplayedTheatre]
        }
    }
    
}
