
import Foundation
import UIKit
import PromiseKit

protocol MainMovieListBusinessLogic {
    func loadMoviesFromNetwork(for location: String)
    func loadCachedMovies(request: MainMovieList.Request)
    func getMovieAtIndex(_ index: Int) -> Movie_R?
}

protocol MainMovieListDataStore {
    var movies: [Movie_R]? { get }
}

final class MainMovieListInteractor: MainMovieListBusinessLogic, MainMovieListDataStore {
    
    var presenter: MainMovieListPresentationLogic?
    var moviesWorker = MovieWorker()
    var movies: [Movie_R]?
    lazy var privateRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.secret)
    }()
    
    func loadCachedMovies(request: MainMovieList.Request) {
        let resource = Movie_R.moviesResource(for: request.location)
        if let cachedMovies = moviesWorker.loadCachedMovies(resource) {
            self.saveMoviesToDataStore(cachedMovies)
            self.generateResponseForPresenter(with: cachedMovies)
        }
    }
    
    func loadMoviesFromNetwork(for location: String) {
        let resource = Movie_R.moviesResource(for: location)
        self.moviesWorker
            .fetchCurrentlyPlayingMovies(resource)
            .then { [weak self] (movies) -> Void in
                self?.saveMoviesToDataStore(movies)
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
    
    func getMovieAtIndex(_ index: Int) -> Movie_R? {
        guard let movies = movies, index < movies.count else { return nil }
        return movies[index]
    }

}

extension MainMovieListInteractor {
    
    fileprivate func generateResponseForPresenter(with movies: [Movie_R]?) {
        let response = MainMovieList.Response(movies: movies ?? nil)
        self.presenter?.presentMovieList(response: response)
    }
    
}

extension MainMovieListInteractor {
    
    fileprivate func saveMoviesToDataStore(_ movies: [Movie_R]) {
        self.movies = movies
    }
    
}
