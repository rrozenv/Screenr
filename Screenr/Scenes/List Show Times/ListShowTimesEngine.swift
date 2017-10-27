
import Foundation

protocol ListShowtimesDataStore {
    var movie: Movie_R! { get set }
}

protocol ListShowtimesBusinessLogic {
    func getMovieShowtimes(request: ListShowtimes.GetShowtimes.Request)
}

final class ListShowtimesEngine: ListShowtimesDataStore, ListShowtimesBusinessLogic {
    
    var movie: Movie_R! //Data is passed from MainMovieList Scene
    var presenter: ListShowtimesPresentationLogic?
    var moviesWorker = MovieWorker()
    
    func getMovieShowtimes(request: ListShowtimes.GetShowtimes.Request) {
        
        guard let location = request.location, let date = request.date else {
            let response = ListShowtimes.GetShowtimes.Response(movie: movie)
            presenter?.presentMovieShowtimes(response: response)
            return
        }
        
        let resource = movieShowtimesResource(location: location, date: date, movieId: movie.movieID)
        moviesWorker
            .fetchShowtimesForMovie(resource)
            .then { [weak self] (movie) -> Void in
                guard let strongSelf = self else { return }
                //TODO: - Fetch details for each theatre
                let response = ListShowtimes.GetShowtimes.Response(movie: movie)
                strongSelf.presenter?.presentMovieShowtimes(response: response)
            }
            .catch { (error) -> Void in
                print("ERROR: \(error)")
                print("ERROR: \(error.localizedDescription)")
        }
        
    }
    
    private func movieShowtimesResource(location: String, date: String, movieId: String) -> Resource<Movie_R> {
        return Resource<Movie_R>(target: .movieShowtimes(id: movieId, date: date, location: location)) { json in
            guard let dictionaries = json as? [JSONDictionary] else { return nil }
            return dictionaries.flatMap(Movie_R.init).first
        }
    }
    
}
