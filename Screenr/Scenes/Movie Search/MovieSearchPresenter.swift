
import Foundation

typealias DisplayedMovieInSearch = MoviesSearch.ViewModel.DisplayedMovie

protocol MovieSearchPresentationLogic {
    func formatMovies(response: MoviesSearch.Response)
}

class MovieSearchPresenter: MovieSearchPresentationLogic {
    
    weak var viewController: MovieSearchViewController?
    
    func formatMovies(response: MoviesSearch.Response) {
        let formattedMovies = formatMoviesForDisplay(response.movies)
        let viewModel = MoviesSearch.ViewModel(displayedMovies: formattedMovies)
        viewController?.displayMovies(viewModel: viewModel)
    }
    
    private func formatMoviesForDisplay(_ movies: [Movie_R]) -> [MoviesSearch.ViewModel.DisplayedMovie] {
        return movies.map({ (movie) -> DisplayedMovieInSearch in
            let displayedMovie = DisplayedMovieInSearch(id: movie.movieID, title: movie.title, year: movie.year, posterURL: movie.posterURL)
            return displayedMovie
        })
    }
    
}
