
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
    lazy var privateRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.secret)
    }()
    
    func loadCachedMovies(request: MainMovieList.Request) {
        let resource = Movie_R.resource(for: request.location)
        if let cachedMovies = moviesWorker.loadCachedMovies(resource) {
            self.saveMoviesToDataStore(cachedMovies)
            self.generateResponseForPresenter(with: cachedMovies)
        }
    }
    
    func loadMoviesFromNetwork(for location: String) {
        self.saveCurrentLocationToDefaults(location: location)
        self.saveLocationInDatabase(location)
        
        let resource = Movie_R.resource(for: location)
        fetchMovies(resource)
        
        presenter?.displayUpdatedLocation(location: location)
    }

}

extension MainMovieListInteractor {
    
    fileprivate func fetchMovies(_ resource: Resource<[Movie_R]>) {
        moviesWorker
            .fetchCurrentlyPlayingMovies(resource)
            .then { [weak self] movies -> Void in
                guard let strongSelf = self else { return }
                strongSelf.saveMoviesToDataStore(movies)
                strongSelf.generateResponseForPresenter(with: movies)
            }
            .catch { [weak self] (error) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.generateResponseForPresenter(with: nil)
                print(error.localizedDescription)
        }
    }
    
    fileprivate func generateResponseForPresenter(with movies: [Movie_R]?) {
        if let movies = movies {
            let response = MainMovieList.Response(movies: movies)
            self.presenter?.presentMovieList(response: response)
        } else {
            let response = MainMovieList.Response(movies: nil)
            self.presenter?.presentMovieList(response: response)
        }
    }
    
}

extension MainMovieListInteractor {
    
    fileprivate func saveCurrentLocationToDefaults(location: String) {
        DefaultsProperty<String>(.currentLocation).value = location
    }
    
    fileprivate func saveLocationInDatabase(_ location: String) {
        //Check if location is already saved first
        let predicate = NSPredicate(format: "code == %@", "\(location)")
        privateRealm
            .fetch(Location_R.self, predicate: predicate, sorted: nil)
            .then { [weak self] (locations) -> Void in
                if locations.count < 1 {
                    self?.createNewLocation(location)
                }
            }
            .catch { (error) in
                print(error.localizedDescription)
            }
    }
    
    fileprivate func createNewLocation(_ location: String) {
        let value = ["code": location]
        privateRealm
            .create(Location_R.self, value: value)
            .catch { (error) in
                print(error.localizedDescription)
            }
    }
    
    fileprivate func saveMoviesToDataStore(_ movies: [Movie_R]) {
        self.movies = movies
    }
    
}
