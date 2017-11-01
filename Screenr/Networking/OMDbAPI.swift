
import Foundation
import Moya

enum OMDbAPI {
    
    static var cacheKey: String {
        let base = "http://www.omdbapi.com"
        let path = "search"
        return String(base.hashValue + path.hashValue)
    }
    
    case search(query: String)
}

extension OMDbAPI: TargetType {
    
    // 3:
    var baseURL: URL {
        switch self {
        case .search(query: _):
            return URL(string: "http://www.omdbapi.com")!
        }
    }
    
    // 4:
    var path: String {
        switch self {
        case .search(query: _):
            return ""
        }
    }
    
    // 5:
    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
    // 6:
    var parameters: [String: Any]? {
        switch self {
        case .search(query: let query):
            var parameters = [String: Any]()
            parameters["s"] = "\(query)"
            parameters["api_key"] = Secrets.API_Key
            return parameters
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    // 7:
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    // 8:
    var sampleData: Data {
        return Data()
    }
    
    // 9:
    var task: Task {
        return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
    }
}
