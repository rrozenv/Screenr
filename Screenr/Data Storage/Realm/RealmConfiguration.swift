
import Foundation
import RealmSwift

struct Constants {
    static let defaultSyncHost = "192.168.1.4"
    static let syncAuthURL = URL(string: "http://\(defaultSyncHost):9080")!
    static let syncServerURL = URL(string: "realm://\(defaultSyncHost):9080/")
    static let commonRealmURL = URL(string: "realm://\(defaultSyncHost):9080/CommonRealm")!
    static let privateRealmURL = URL(string: "realm://\(defaultSyncHost):9080/~/privateRealm")!
    static let temporaryRealmURL = URL(string: "realm://\(defaultSyncHost):9080/~/temporaryRealm")!
}

enum RealmConfig {
    
    case common
    case secret
    case temporary
    
    var configuration: Realm.Configuration {
        switch self {
        case .common:
            return RealmConfig.commonRealmConfig(user: SyncUser.current!)
        case .secret:
            return RealmConfig.privateRealmConfig(user: SyncUser.current!)
        case .temporary:
            return RealmConfig.temporaryRealmConfig(user: SyncUser.current!)
        }
    }
    
    private static func commonRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.commonRealmURL), objectTypes: [User.self, Movie_R.self, Theatre_R.self, Showtime_R.self, Contest_R.self, ContestMovie_R.self])
        return config
    }
    
    private static func privateRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.privateRealmURL), objectTypes: [Theatre_R.self, Location_R.self])
        return config
    }
    
    private static func temporaryRealmConfig(user: SyncUser) -> Realm.Configuration  {
        let config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: SyncUser.current!, realmURL: Constants.temporaryRealmURL), objectTypes: [ContestMovie_R.self, Theatre_R.self])
        return config
    }
    
}
