
import Foundation
import UIKit

protocol CreateContestSummaryPresentationLogic {
    func formatMovies(response: CreateContestSummary.SelectedMovies.Response)
}

final class CreateContestSummaryPresenter: CreateContestSummaryPresentationLogic {
    
    weak var viewController: CreateContestSummaryViewController?
    
    func formatMovies(response:  CreateContestSummary.SelectedMovies.Response) {
        let formattedMovies = formatMoviesForDisplay(response.movies)
        let viewModel = SelectMovies.ViewModel(displayedMovies: formattedMovies)
        viewController?.displaySelectedMovies(viewModel: viewModel)
    }
    
    private func formatMoviesForDisplay(_ movies: [Movie_R]) -> [DisplayedMovie] {
        return movies.map({ (movie) -> DisplayedMovie in
            let displayedMovie = DisplayedMovie(id: movie.movieID, title: movie.title, year: movie.year, posterURL: movie.posterURL)
            return displayedMovie
        })
    }
    
}
