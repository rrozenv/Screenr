
import Foundation

struct FileStorage {
    let baseURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    subscript(key: String) -> Data? {
        get {
            let url = baseURL.appendingPathComponent(key)
            return try? Data(contentsOf: url)
        }
        set {
            let url = baseURL.appendingPathComponent(key)
            _ = try? newValue?.write(to: url)
        }
    }
}

final class Cache {
    
    static let shared = Cache()
    private var storage = FileStorage()
   
    private init () { }
    
    func load<T>(_ resource: Resource<T>) -> T? {
        let data = storage[resource.target.cacheKey]
        return data.flatMap(resource.parse)
    }
    
    func saveData<T>(_ data: Data, for resource: Resource<T>) {
        storage[resource.target.cacheKey] = data
    }
    
}
