
import Foundation
import UIKit
import PromiseKit

protocol MainMovieListBusinessLogic {
    func loadMoviesFromNetwork(for location: String)
    func loadCachedMovies(request: MainMovieList.Request)
    //func saveCurrentLocationToDefaults(_ location: String)
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
        //self.saveLocationInDatabase(location)
        let resource = Movie_R.moviesResource(for: location)
        self.fetchMovies(resource)
    }
    
    func getMovieAtIndex(_ index: Int) -> Movie_R? {
        guard let movies = movies, index < movies.count else { return nil }
        return movies[index]
    }

}

extension MainMovieListInteractor {
    
    fileprivate func fetchMovies(_ resource: Resource<[Movie_R]>) {
        self.moviesWorker
            .fetchCurrentlyPlayingMovies(resource)
            .then { [weak self] movies -> Void in
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
    
    fileprivate func generateResponseForPresenter(with movies: [Movie_R]?) {
        let response = MainMovieList.Response(movies: movies ?? nil)
        self.presenter?.presentMovieList(response: response)
    }
    
}

extension MainMovieListInteractor {
    
//    fileprivate func saveLocationInDatabase(_ location: String) {
//        //Check if location is already saved first
//        let predicate = NSPredicate(format: "code == %@", "\(location)")
//        self.privateRealm
//            .fetch(Location_R.self, predicate: predicate, sorted: nil)
//            .then { [weak self] (locations) -> Void in
//                if locations.count < 1 {
//                    self?.createNewLocation(location)
//                }
//            }
//            .catch { (error) in
//                print(error.localizedDescription)
//            }
//    }
//    
//    fileprivate func createNewLocation(_ location: String) {
//        let value = ["code": location]
//        self.privateRealm
//            .create(Location_R.self, value: value)
//            .catch { (error) in
//                if let realmError = error as? RealmError {
//                    print(realmError.description)
//                } else {
//                    print(error.localizedDescription)
//                }
//            }
//    }
    
    fileprivate func saveMoviesToDataStore(_ movies: [Movie_R]) {
        self.movies = movies
    }
    
}
