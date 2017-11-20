
import Foundation

enum MainMovieList {
    
    //User Input -> Interactor Input
    enum GetMovies {
        
    }
    
    enum SaveMovie {
        struct Request {
            var movieId: String
        }
    }
    
    struct Request {
        var location: String?
    }
    
    //Interactor Output -> Presenter Input
    struct Response {
        var movies: [Movie_R]?
    }
    
    //Presenter Output -> View Controller Input
    struct ViewModel {
        var movies: [DisplayedMovie]?
    }
    
    struct Alert {
        static func failedFetchingMovies() -> CustomAlertViewController.AlertInfo {
            return CustomAlertViewController.AlertInfo(header: "Failed Fetching Movies", message: "Oops!", okButtonTitle: "OK", cancelButtonTitle: nil)
        }
    }
    
    struct Seeds {
        static func genearteTestMovies() -> [Movie_R] {
            let movieOne = Movie_R()
            movieOne.movieID = "1"
            movieOne.year = "1999"
            let movieTwo = Movie_R()
            movieTwo.movieID = "2"
            movieTwo.year = "2000"
            return [movieOne, movieTwo]
        }
    }
    
}
