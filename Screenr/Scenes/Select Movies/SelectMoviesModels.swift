
import Foundation

enum SelectMovies {
    
    //User Input -> Interactor Input
    struct Request {
        let movie: Movie_R
    }
    
    //Interactor Output -> Presenter Input
    struct Response {
        var movies: [Movie_R]
    }
    
    //Presenter Output -> View Controller Input
    struct ViewModel {
        struct DisplayedMovie {
            let id: String
            let title: String
            let year: String
            let posterURL: String
        }
        var displayedMovies: [DisplayedMovie]
    }
    
}
