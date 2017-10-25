
import Foundation
import UIKit

protocol MainMovieListPresentationLogic {
    func presentCachedMovieList(response: MainMovieList.Response)
    func presentMovieList(response: MainMovieList.Response)
}

class MainMovieListPresenter: MainMovieListPresentationLogic {
    
    weak var viewController: MainMovieListViewController?
    
    func presentCachedMovieList(response: MainMovieList.Response) {
        guard let movies = response.movies else { return }
        let formattedMovies = formatMoviesForDisplay(movies)
        let viewModel = MainMovieList.ViewModel(movies: formattedMovies)
        viewController?.displayMoviesFromCache(viewModel: viewModel)
    }
    
    func presentMovieList(response: MainMovieList.Response) {
        guard let movies = response.movies else { displayEmptyMovieList() ; return }
        let formattedMovies = formatMoviesForDisplay(movies)
        let viewModel = MainMovieList.ViewModel(movies: formattedMovies)
        viewController?.displayMoviesFromNetwork(viewModel: viewModel)
    }
    
    private func formatMoviesForDisplay(_ movies: [Movie]) -> [MainMovieList.ViewModel.DisplayedMovie] {
        return movies.map({ (movie) -> MainMovieList.ViewModel.DisplayedMovie in
            let title = movie.title.uppercased()
            let displayedMovie = MainMovieList.ViewModel.DisplayedMovie(id: movie.id, title: title)
            return displayedMovie
        })
    }
    
    private func displayEmptyMovieList() {
        let viewModel = MainMovieList.ViewModel(movies: nil)
        viewController?.displayMoviesFromNetwork(viewModel: viewModel)
    }
    
}
