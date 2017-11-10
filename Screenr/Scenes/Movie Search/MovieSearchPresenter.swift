
import Foundation

typealias DisplayedMovieInSearch = MoviesSearch.ContestMovies.ViewModel.DisplayedMovie

protocol MovieSearchPresentationLogic {
    func formatMovies(response: MoviesSearch.ContestMovies.Response)
}

class MovieSearchPresenter: MovieSearchPresentationLogic {
    
    weak var viewController: MovieSearchViewController?
    
    func formatMovies(response: MoviesSearch.ContestMovies.Response) {
        let formattedMovies = formatMoviesForDisplay(response.movies)
        let viewModel = MoviesSearch.ContestMovies.ViewModel(displayedMovies: formattedMovies)
        viewController?.displayMovies(viewModel: viewModel)
    }
    
    private func formatMoviesForDisplay(_ movies: [ContestMovie_R]) -> [MoviesSearch.ContestMovies.ViewModel.DisplayedMovie] {
        return movies.map({ (movie) -> DisplayedMovieInSearch in
            let displayedMovie = DisplayedMovieInSearch(id: movie.movieID, title: movie.title, year: movie.year, posterURL: movie.posterURL)
            return displayedMovie
        })
    }
    
}
