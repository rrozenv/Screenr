
import Foundation
import UIKit
import PromiseKit

protocol MainMovieListBusinessLogic {
    func loadMoviesFromNetwork(for location: String)
    func loadCachedMovies(request: MainMovieList.Request)
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
    
    func loadMoviesFromNetwork(for location: String) {
        let resource = Movie_R.moviesResource(for: location)
        self.moviesWorker
            .fetchCurrentlyPlayingMovies(resource)
            .then { [weak self] (movies) -> Void in
                self?.movies = movies
                self?.generateResponseForPresenter(with: movies)
            }
            .catch { [weak self] (error) -> Void in
                self?.generateResponseForPresenter(with: nil)
                if let httpError = error as? HTTPError {
                    print(httpError.description)
                } else {
                    print(error.localizedDescription)
                }
            }
    }

}

extension MainMovieListInteractor {
    
    fileprivate func generateResponseForPresenter(with movies: [Movie_R]?) {
        let response = MainMovieList.Response(movies: movies ?? nil)
        self.presenter?.presentMovieList(response: response)
    }
    
}


