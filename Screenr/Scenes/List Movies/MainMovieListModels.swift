
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
    
}
