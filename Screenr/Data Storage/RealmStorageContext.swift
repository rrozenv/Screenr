
import Foundation
import RealmSwift
import PromiseKit

public struct Sorted {
    var key: String
    var ascending: Bool = true
}

protocol RealmStorageFunctions {
    func save(object: Object)
    func create<T: Object>(_ model: T.Type, value: [String: Any]?, completion: @escaping ((T) -> Void))
    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}

class RealmStorageContext: RealmStorageFunctions {

    var realm: Realm?
    
    required init(configuration: RealmConfig) {
        self.realm = try! Realm(configuration: configuration.configuration)
    }
    
    func create<T: Object>(_ model: T.Type, value: [String: Any]?, completion: @escaping ((T) -> Void)) {
        guard let realm = self.realm else { return }
        
        try! realm.write {
            let newObject = realm.create(model as Object.Type, value: value ?? [], update: false) as! T
            completion(newObject)
        }
    }
    
    func save(object: Object) {
        guard let realm = self.realm else { return }
        
        try! realm.write {
            realm.add(object)
        }
    }
    
    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> ())) {
        var objects = self.realm?.objects(model as Object.Type)

        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }

        if let sorted = sorted {
            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        
        completion(objects!.flatMap { $0 as? T })
    }
    
    func update(block: @escaping () -> Void) {
        guard let realm = self.realm else { return }
        
        try! realm.write {
            block()
        }
    }

}


