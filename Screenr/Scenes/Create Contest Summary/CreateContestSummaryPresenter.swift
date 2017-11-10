
import Foundation
import UIKit

protocol CreateContestSummaryPresentationLogic {
    func formatMovies(response: CreateContestSummary.SelectedMovies.Response)
    func formatTheatre(response: CreateContestSummary.SelectedTheatre.Response)
    func displayUpdatedDate()
    func displayUpdatedPrice()
    func displayUpdatedVotesRequired()
    func displayDidCreateContestConfirmation()
}

final class CreateContestSummaryPresenter: CreateContestSummaryPresentationLogic {
    
    weak var viewController: CreateContestSummaryViewController?
    
    func formatMovies(response:  CreateContestSummary.SelectedMovies.Response) {
        let formattedMovies = formatMoviesForDisplay(response.movies)
        let viewModel = SelectMovies.ViewModel(displayedMovies: formattedMovies)
        viewController?.displaySelectedMovies(viewModel: viewModel)
    }
    
    func formatTheatre(response: CreateContestSummary.SelectedTheatre.Response) {
        let viewModel = CreateContestSummary.SelectedTheatre.ViewModel(displayedTheatre: response.theatre)
        viewController?.displaySelectedTheatre(viewModel: viewModel)
    }
    
    func displayDidCreateContestConfirmation() {
        viewController?.displayDidCreateContestConfirmation()
    }
    
    func displayUpdatedDate() {
        viewController?.displayUpdatedDate()
    }
    
    func displayUpdatedPrice() {
        viewController?.displayUpdatedPrice()
    }
    
    func displayUpdatedVotesRequired() {
        viewController?.displayUpdatedVotesRequired()
    }
    
    private func formatMoviesForDisplay(_ movies: [ContestMovie_R]) -> [DisplayedMovie] {
        return movies.map({ (movie) -> DisplayedMovie in
            let displayedMovie = DisplayedMovie(id: movie.movieID, title: movie.title, year: movie.year, posterURL: movie.posterURL)
            return displayedMovie
        })
    }
    
}
