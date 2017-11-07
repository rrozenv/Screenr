
import Foundation

enum CalendarDays {
    
    enum GetCalanderDays {
        //User Input -> Interactor Input
        struct Request { }
        
        //Interactor Output -> Presenter Input
        struct Response {
            var dates: [Date]
        }
        
        //Presenter Output -> View Controller Input
        struct ViewModel {
            struct DisplayedDate {
                let fullDateString: String
                let calendarDay: String
                let month: String
                let weekDay: String
            }
            var displayedDates: [DisplayedDate]
        }
    }
    
}

