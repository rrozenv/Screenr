
import Foundation

protocol CreateContestSummaryLogic {
    func fetchSelectedMoviesFromDatabase()
    func updateTicketPrice(to price: String)
    func updateVotesRequired(to numberOfVotes: String)
}

protocol CreateContestSummaryDataStore {
    var selectedMovies: [Movie_R] { get set }
    var ticketPrice: String { get set }
    var votesRequired: String { get set }
}

final class CreateContestSummaryEngine: CreateContestSummaryLogic, CreateContestSummaryDataStore {
    
    var selectedMovies = [Movie_R]()
    var presenter: CreateContestSummaryPresentationLogic?
    var ticketPrice: String = TextFieldCell.Style.price.defaultValue
    var votesRequired: String = TextFieldCell.Style.votes.defaultValue
    
    lazy var temporaryRealm: RealmStorageContext = {
        return RealmStorageContext(configuration: RealmConfig.temporary)
    }()
    
    func fetchSelectedMoviesFromDatabase() {
        self.temporaryRealm
            .fetch(Movie_R.self)
            .then { (movies) -> Void in
                self.selectedMovies = movies
                let response = CreateContestSummary.SelectedMovies.Response(movies: movies)
                self.presenter?.formatMovies(response: response)
            }
            .catch { (error) in
                if let realmError = error as? RealmError {
                    print(realmError.description)
                } else {
                    print(error.localizedDescription)
                }
            }
    }
    
    func updateTicketPrice(to price: String) {
        self.ticketPrice = price
        self.presenter?.displayUpdatedPrice()
    }
    
    func updateVotesRequired(to numberOfVotes: String) {
        self.votesRequired = numberOfVotes
        self.presenter?.displayUpdatedVotesRequired()
    }
    
}
