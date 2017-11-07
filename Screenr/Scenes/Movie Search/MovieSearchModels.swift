
import Foundation

enum MoviesSearch {
    
    //User Input -> Interactor Input
    enum ContestMovies {
        struct Request {
            let query: String
        }
        
        //Interactor Output -> Presenter Input
        struct Response {
            var movies: [ContestMovie_R]
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
    
    enum Movies {
        struct Request {
            let query: String
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
    
    enum Theatres {
        struct Request {
            let query: String
        }
        
        //Interactor Output -> Presenter Input
        struct Response {
            var theatres: [Theatre_R]
        }
        
        //Presenter Output -> View Controller Input
        struct ViewModel {
            struct DisplayedTheatre {
                let id: String
                let name: String
            }
            var displayedMovies: [DisplayedTheatre]
        }
    }
  
    
}
