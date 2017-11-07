
import Foundation
import UIKit

protocol CreateContestSummaryPresentationLogic {
    func formatMovies(response: CreateContestSummary.SelectedMovies.Response)
    func displayUpdatedPrice()
    func displayUpdatedVotesRequired()
}

final class CreateContestSummaryPresenter: CreateContestSummaryPresentationLogic {
    
    weak var viewController: CreateContestSummaryViewController?
    
    func formatMovies(response:  CreateContestSummary.SelectedMovies.Response) {
        let formattedMovies = formatMoviesForDisplay(response.movies)
        let viewModel = SelectMovies.ViewModel(displayedMovies: formattedMovies)
        viewController?.displaySelectedMovies(viewModel: viewModel)
    }
    
    func displayUpdatedPrice() {
        viewController?.displayUpdatedPrice()
    }
    
    func displayUpdatedVotesRequired() {
        viewController?.displayUpdatedVotesRequired()
    }
    
    private func formatMoviesForDisplay(_ movies: [Movie_R]) -> [DisplayedMovie] {
        return movies.map({ (movie) -> DisplayedMovie in
            let displayedMovie = DisplayedMovie(id: movie.movieID, title: movie.title, year: movie.year, posterURL: movie.posterURL)
            return displayedMovie
        })
    }
    
}
