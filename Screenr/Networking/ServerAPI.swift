
import Foundation
import Moya

enum ServerAPI {
    
    static var cacheKey: String {
        let base = "https://data.tmsapi.com/v1.1"
        let path = "/movies/showings"
        return String(base.hashValue + path.hashValue)
    }
    
    // MARK: - Movies
    case currentMovies(location: String)
    case getImage(uri: String)
    case movieShowtimes(id: String, date: String, location: String)
    
    // MARK: - User
}

extension ServerAPI: TargetType {
    
    // 3:
    var baseURL: URL {
        switch self {
        case .currentMovies(location: _):
            return URL(string: "https://data.tmsapi.com/v1.1")!
        case .getImage(uri: let uri):
            return URL(string: "https://data.tmsapi.com/v1.1\(uri)")!
        default:
            return URL(string: "https://data.tmsapi.com/v1.1")!
        }
        
    }
    
    // 4:
    var path: String {
        switch self {
        case .currentMovies(_):
            return "/movies/showings"
        case .getImage(uri: _):
            return ""
        case .movieShowtimes(id: let id, _ , _ ):
           return "/movies/\(id)/showings"
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
        case .currentMovies(let location):
            var parameters = [String: Any]()
            parameters["startDate"] = Date().yearMonthDayString
            parameters["zip"] = location
            parameters["api_key"] = Secrets.API_Key
            return parameters
        case .movieShowtimes( _ , date: let date, location: let location):
            var parameters = [String: Any]()
            parameters["startDate"] = date
            parameters["zip"] = location
            parameters["api_key"] = Secrets.API_Key
            return parameters
        case .getImage(uri: _):
            var parameters = [String: Any]()
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
