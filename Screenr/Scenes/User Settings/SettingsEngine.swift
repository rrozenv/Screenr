
import Foundation

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
//            guard RealmManager.isDefaultRealmConfigured() else { return }
            RealmManager.resetDefaultRealm()
            NotificationCenter.default.post(name: .logout, object: nil)
        }
    }
    
}
