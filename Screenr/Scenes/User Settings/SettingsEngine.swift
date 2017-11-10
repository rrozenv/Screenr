
import Foundation
import CoreLocation

protocol SettingsBusinessLogic {
    func createSettingsOptions()
}

final class SettingsEngine: SettingsBusinessLogic {
    
    var presenter: SettingsPresentationLogic?
    
    func createSettingsOptions() {
        let logoutSetting = createLogoutSetting()
        let response = SO_Settings.CreateOptions.Response(settings: [logoutSetting])
        presenter?.displaySettings(response: response)
    }
    
}

extension SettingsEngine {
    
    fileprivate func createLogoutSetting() -> Setting {
        return Setting(type: .logout) {
            RealmLoginManager.resetDefaultRealm()
            NotificationCenter.default.post(name: .logout, object: nil)
        }
    }
    
}
