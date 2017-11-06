

import Foundation

enum CreateContestSummary {
    
    enum SelectedMovies {
        struct Response {
            var movies: [Movie_R]
        }
        struct ViewModel {
            var displayedMovies: [DisplayedMovie]
        }
    }

}
