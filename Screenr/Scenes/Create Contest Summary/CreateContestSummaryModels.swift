

import Foundation

enum CreateContestSummary {
    
    enum SelectedMovies {
        struct Response {
            var movies: [ContestMovie_R]
        }
        struct ViewModel {
            var displayedMovies: [DisplayedMovie]
        }
    }
    
    enum SelectedTheatre {
        struct Response {
            var theatre: Theatre_R
        }
        struct ViewModel {
            var displayedTheatre: Theatre_R
        }
    }

}
