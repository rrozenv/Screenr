
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
        var location: String
    }
    
    //Interactor Output -> Presenter Input
    struct Response {
        var movies: [Movie]?
    }
    
    //Presenter Output -> View Controller Input
    struct ViewModel {
        struct DisplayedMovie {
            var id: String
            var title: String
        }
        var movies: [DisplayedMovie]?
    }
    
    
}
