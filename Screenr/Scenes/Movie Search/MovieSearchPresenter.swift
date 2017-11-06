
import Foundation

typealias DisplayedMovieInSearch = MoviesSearch.Movies.ViewModel.DisplayedMovie

protocol MovieSearchPresentationLogic {
    func formatMovies(response: MoviesSearch.Movies.Response)
}

class MovieSearchPresenter: MovieSearchPresentationLogic {
    
    weak var viewController: MovieSearchViewController?
    
    func formatMovies(response: MoviesSearch.Movies.Response) {
        let formattedMovies = formatMoviesForDisplay(response.movies)
        let viewModel = MoviesSearch.Movies.ViewModel(displayedMovies: formattedMovies)
        viewController?.displayMovies(viewModel: viewModel)
    }
    
    private func formatMoviesForDisplay(_ movies: [Movie_R]) -> [MoviesSearch.Movies.ViewModel.DisplayedMovie] {
        return movies.map({ (movie) -> DisplayedMovieInSearch in
            let displayedMovie = DisplayedMovieInSearch(id: movie.movieID, title: movie.title, year: movie.year, posterURL: movie.posterURL)
            return displayedMovie
        })
    }
    
}
