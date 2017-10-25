//
//  SettingsSharedObjects.swift
//  Screenr
//
//  Created by Robert Rozenvasser on 10/25/17.
//  Copyright © 2017 GoKid. All rights reserved.
//

import Foundation

enum SettingType: String {
    case logout = "Logout"
}

struct Setting {
    let type: SettingType
    let action: () -> Void
}

enum SO_Settings {
    
    enum CreateOptions {
        
        //User Input -> Interactor Input
        struct Request { }
        
        //Interactor Output -> Presenter Input
        struct Response {
            var settings: [Setting]
        }
        
        //Presenter Output -> View Controller Input
        struct ViewModel {
            var displayedSettings: [Setting]
        }
        
    }

}
