
import Foundation

enum ListContests {
    
    enum FetchContests {
      
        struct Request {
            //TODO: By location
        }
        
        struct Response {
            var contests: [Contest_R]
        }
        
        //Presenter Output -> View Controller Input
        struct ViewModel {
            struct DisplayedContest {
                let theatreName: String
                let ticketPrice: String
                let votesRequired: String
                let calendarDate: String
                let movies: [ContestMovie_R]
            }
            var displayedContests: [DisplayedContest]
        }
    }
    
}
