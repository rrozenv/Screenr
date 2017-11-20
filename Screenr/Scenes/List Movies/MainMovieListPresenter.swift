
import Foundation
import UIKit

protocol MainMovieListPresentationLogic {
    func presentMovieList(response: MainMovieList.Response)
}

class MainMovieListPresenter: MainMovieListPresentationLogic {
    
    weak var viewController: MainMovieListDisplayLogic?
 
    func presentMovieList(response: MainMovieList.Response) {
        guard let movies = response.movies else { displayEmptyMovieList() ; return }
        let formattedMovies = formatMoviesForDisplay(movies)
        let viewModel = MainMovieList.ViewModel(movies: formattedMovies)
        viewController?.displayMoviesFromNetwork(viewModel: viewModel)
    }

    private func formatMoviesForDisplay(_ movies: [Movie_R]) -> [DisplayedMovie] {
        return movies.map({ (movie) -> DisplayedMovie in
            let title = movie.title.uppercased()
            let displayedMovie = DisplayedMovie(id: movie.movieID, title: title, year: nil, posterURL: nil)
            return displayedMovie
        })
    }
    
    private func displayEmptyMovieList() {
        let viewModel = MainMovieList.ViewModel(movies: nil)
        viewController?.displayMoviesFromNetwork(viewModel: viewModel)
    }
    
}
