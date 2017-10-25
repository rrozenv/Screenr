
import Foundation
import UIKit

protocol SettingsPresentationLogic {
    func displaySettings(response: SO_Settings.CreateOptions.Response)
}

class SettingsPresenter: SettingsPresentationLogic {
    
    weak var viewController: SettingsViewController?
    
    func displaySettings(response: SO_Settings.CreateOptions.Response) {
        let viewModel = SO_Settings.CreateOptions.ViewModel(displayedSettings: response.settings)
        viewController?.displaySettingsOptions(viewModel: viewModel)
    }
    
}
