
import Foundation
import UIKit
import PromiseKit

protocol MainMovieListBusinessLogic {
    func loadCachedMovies(request: MainMovieList.Request)
    func fetchMoviesFromNetwork(for location: String)
}

protocol MainMovieListDataStore {
    var movies: [Movie_R]? { get }
}

final class MainMovieListInteractor: MainMovieListBusinessLogic, MainMovieListDataStore {
    
    var presenter: MainMovieListPresentationLogic?
    var moviesWorker = MovieWorker()
    var movies: [Movie_R]?
    
    func loadCachedMovies(request: MainMovieList.Request) {
        let resource = Movie_R.moviesResource(for: request.location)
        if let cachedMovies = moviesWorker.loadCachedMovies(resource) {
            self.movies = cachedMovies
            self.generateResponseForPresenter(with: cachedMovies)
        }
    }
    
    func fetchMoviesFromNetwork(for location: String) {
        let resource = Movie_R.moviesResource(for: location)
        self.moviesWorker
            .fetchCurrentlyPlayingMovies(resource) { [weak self] (movies, _) in
                //movies = nil if error exists
                self?.generateResponseForPresenter(with: movies)
            }
    }

}

extension MainMovieListInteractor {
    
    fileprivate func generateResponseForPresenter(with movies: [Movie_R]?) {
        let response = MainMovieList.Response(movies: movies ?? nil)
        self.presenter?.presentMovieList(response: response)
    }
    
}


