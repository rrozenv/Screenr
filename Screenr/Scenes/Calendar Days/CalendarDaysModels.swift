//
//  CalendarDaysModels.swift
//  Screenr
//
//  Created by Robert Rozenvasser on 10/21/17.
//  Copyright © 2017 GoKid. All rights reserved.
//

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

