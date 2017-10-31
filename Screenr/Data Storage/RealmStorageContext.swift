//
//import Foundation
//import RealmSwift
//import PromiseKit
//
//public struct Sorted {
//    var key: String
//    var ascending: Bool = true
//}
//
//protocol RealmStorageFunctions {
//    func create<T: Object>(_ model: T.Type) -> Promise<T>
//    func save(object: Object) throws
//    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
//}
//
//class RealmStorageContext: RealmStorageFunctions {
//    var realm: Realm?
//    required init(configuration: RealmConfig) {
//        self.realm = try! Realm(configuration: configuration.configuration)
//    }
//
//    func safeWrite(_ block: (() throws -> Void)) throws {
//        guard let realm = self.realm else {
//            throw NSError()
//        }
//
//        if realm.isInWriteTransaction {
//            try block()
//        } else {
//            try realm.write(block)
//        }
//    }
//}
//
//extension RealmStorageContext {
//    func create<T: Object>(_ model: T.Type) -> Promise<T> {
//        return Promise { fullfill, reject in
//            guard let realm = self.realm else {
//                reject(NSError())
//            }
//
//            try self.safeWrite {
//                let newObject = realm.create(model as Object.Type, value: [], update: false) as! T
//                fullfill(newObject)
//            }
//        }
//    }
//
//    func save(object: Object) throws {
//        guard let realm = self.realm else {
//            throw NSError()
//        }
//
//        try self.safeWrite {
//            realm.add(object)
//        }
//    }
//
//    func fetch<T: Object>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> ())) {
//        var objects = self.realm?.objects(model as Object.Type)
//
//        if let predicate = predicate {
//            objects = objects?.filter(predicate)
//        }
//
//        if let sorted = sorted {
//            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
//        }
//
//        completion(Array(objects!))
//    }
//
//}

