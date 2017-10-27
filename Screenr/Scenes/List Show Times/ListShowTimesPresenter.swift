
import Foundation
import RealmSwift

typealias DisplayedTheatre = ListShowtimes.GetShowtimes.ViewModel.DisplayedTheatre

protocol ListShowtimesPresentationLogic {
    func presentMovieShowtimes(response: ListShowtimes.GetShowtimes.Response)
}

class ListShowtimesPresenter: ListShowtimesPresentationLogic {
    
    weak var viewController: ListShowTimesViewController?
    
    func presentMovieShowtimes(response: ListShowtimes.GetShowtimes.Response) {
        let displayedTheatres = Array(response.movie.theatres).map { (theatre) -> DisplayedTheatre in
            return getShowtimesFor(movie: response.movie, at: theatre)
        }
        let viewModel = ListShowtimes.GetShowtimes.ViewModel(displayedTheaters: displayedTheatres)
        viewController?.displayMovieShowtimes(viewModel: viewModel)
    }

}

extension ListShowtimesPresenter {
    
    fileprivate func getShowtimesFor(movie: Movie_R, at theatre: Theatre_R) -> DisplayedTheatre {
        let showtimes = movie.getShowtimesFor(theatreID: theatre.theatreID)
        let formattedShowtimes = formatShowtimes(showtimes)
        return DisplayedTheatre(theatreID: theatre.theatreID, name: theatre.name, movie: movie, showtimes: formattedShowtimes)
    }
    
    fileprivate func formatShowtimes(_ showtimes: [Showtime_R]) -> [Showtime_R] {
        var formattedShowtimes = [Showtime_R]()
        showtimes.forEach {
            if let formattedShowtime = $0.formattedShowTime {
                formattedShowtimes.append(formattedShowtime)
            }
        }
        return formattedShowtimes
    }
    
}



