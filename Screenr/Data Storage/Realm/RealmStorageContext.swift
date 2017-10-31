
import Foundation
import RealmSwift
import PromiseKit

public struct Sorted {
    var key: String
    var ascending: Bool = true
}

protocol RealmStorageFunctions {
    func save(object: Object) -> Promise<Void>
    func create<T: Object>(_ model: T.Type, value: [String: Any]?) -> Promise<T>
    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> Promise<[T]>
}

class RealmStorageContext: RealmStorageFunctions {
    
    var realm: Realm
    
    required init(configuration: RealmConfig) {
        self.realm = try! Realm(configuration: configuration.configuration)
    }
    
    func create<T: Object>(_ model: T.Type, value: [String: Any]?) -> Promise<T> {
        return Promise { fullfill, reject in
            do {
                try realm.write {
                    let newObject = realm.create(model as Object.Type, value: value ?? [], update: false) as! T
                    fullfill(newObject)
                }
            } catch {
                reject(NSError())
            }
        }
    }
    
    func save(object: Object) -> Promise<Void> {
        return Promise { fullfill, reject in
            do {
                try realm.write {
                    realm.add(object)
                }
                fullfill()
            } catch {
                reject(NSError())
            }
        }
    }
    
    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil) -> Promise<[T]> {
        return Promise { fullfill, reject in
            var objects = self.realm.objects(model as Object.Type)
            
            if let predicate = predicate {
                objects = objects.filter(predicate)
            }
            
            if let sorted = sorted {
                objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
            }
            
            fullfill(objects.flatMap { $0 as? T })
        }
    }
    
    func update(block: @escaping () -> Void) {
        try! realm.write {
            block()
        }
    }

}


