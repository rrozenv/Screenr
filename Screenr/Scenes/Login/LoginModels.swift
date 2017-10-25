
import Foundation
import RealmSwift

enum Login {

    //User Input -> Interactor Input
    struct Request {
        let name: String?
        let email: String
        let password: String
    }
    
    //Interactor Output -> Presenter Input
    struct Response {
        var user: User?
    }
    
    //Presenter Output -> View Controller Input
    struct ViewModel {
        struct DisplayedMessage {
            let header: String
            let body: String
            let isSuccess: Bool
        }
        var displayedMessage: DisplayedMessage
    }
    
}
