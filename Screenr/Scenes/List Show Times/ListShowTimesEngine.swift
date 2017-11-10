
import Foundation

protocol ListShowtimesDataStore {
    var movie: Movie_R! { get set }
}

protocol ListShowtimesBusinessLogic {
    func getMovieShowtimes(request: ListShowtimes.GetShowtimes.Request)
    var movieTitle: String { get }
}

final class ListShowtimesEngine: ListShowtimesDataStore, ListShowtimesBusinessLogic {
    
    var movie: Movie_R! //Data is passed from MainMovieList Scene
    var presenter: ListShowtimesPresentationLogic?
    var moviesWorker = MovieWorker()
    var movieTitle: String {
        return movie.title
    }
    
    func getMovieShowtimes(request: ListShowtimes.GetShowtimes.Request) {
        
        guard let location = request.location, let date = request.date else {
            let response = ListShowtimes.GetShowtimes.Response(movie: movie)
            presenter?.presentMovieShowtimes(response: response)
            return
        }
        
        let resource = Movie_R.showtimesResource(location: location, date: date, movieId: movie.movieID)
        moviesWorker
            .fetchShowtimesForMovie(resource)
            .then { [weak self] (movie) -> Void in
                let response = ListShowtimes.GetShowtimes.Response(movie: movie)
                self?.presenter?.presentMovieShowtimes(response: response)
            }
            .catch { (error) -> Void in
                if let httpError = error as? HTTPError {
                    print(httpError.description)
                } else {
                    print(error.localizedDescription)
                }
        }
        
    }
    
}
