
import Foundation
import Moya
import PromiseKit
import UIKit

typealias JSONDictionary = [String: Any]

struct MovieWorker {
    
    private let webservice = WebService.shared
    private let cache = Cache.shared
    
    func loadCachedMovies(_ resource:  Resource<[Movie]>) -> [Movie]? {
        guard let movies = cache.load(resource) else { return nil }
        return movies
    }
    
    func fetchCurrentlyPlayingMovies(_ resource: Resource<[Movie]>) -> Promise<[Movie]> {
        return webservice.load(resource)
    }
    
    func fetchShowtimesForMovie(_ resource: Resource<Movie>) -> Promise<Movie> {
        return webservice.load(resource)
    }
    
}

//extension MovieWorker {
//
//    func loadImage(_ resource: Resource<UIImage>) -> Promise<UIImage> {
//        guard let image = cache.load(resource) else {
//            return self.loadImageFromNetwork(resource)
//        }
//        return Promise(value: image)
//    }
//
//    private func loadImageFromNetwork(_ resource: Resource<UIImage>) -> Promise<UIImage> {
//        let target = resource.target
//        return Promise { fulfill, fail in
//            NetworkAdapter.request(target: target, success: { (response) in
//                self.cache.saveData(response.data, for: resource)
//                if let image = UIImage(data: response.data) {
//                    fulfill(image)
//                } else {
//                    //
//                }
//            }, error: { (error) in
//                fail(error)
//            }, failure: { (error) in
//                fail(error)
//            })
//        }
//    }
//
//}




