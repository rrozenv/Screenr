
import Foundation

struct DisplayedMovie {
    let id: String
    let title: String
    let year: String?
    let posterURL: String?
}

enum SelectMovies {
    
    //User Input -> Interactor Input
    struct Request {
        let movie: ContestMovie_R
    }
    
    //Interactor Output -> Presenter Input
    struct Response {
        var movies: [ContestMovie_R]
    }
    
    //Presenter Output -> View Controller Input
    struct ViewModel {
        var displayedMovies: [DisplayedMovie]
    }
    
}
