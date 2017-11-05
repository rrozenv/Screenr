
import Foundation

protocol SelectMoviesPresentationLogic {
    func formatMovies(response: SelectMovies.Response)
}

final class SelectMoviesPresenter: SelectMoviesPresentationLogic {
    
    weak var viewController: SelectMoviesViewController?
    
    func formatMovies(response: SelectMovies.Response) {
        let formattedMovies = formatMoviesForDisplay(response.movies)
        let viewModel = SelectMovies.ViewModel(displayedMovies: formattedMovies)
        viewController?.displaySelectedMovies(viewModel: viewModel)
    }
    
    private func formatMoviesForDisplay(_ movies: [Movie_R]) -> [SelectMovies.ViewModel.DisplayedMovie] {
        return movies.map({ (movie) -> SelectMovies.ViewModel.DisplayedMovie in
            let displayedMovie = SelectMovies.ViewModel.DisplayedMovie(id: movie.movieID, title: movie.title, year: movie.year, posterURL: movie.posterURL)
            return displayedMovie
        })
    }
    
}
