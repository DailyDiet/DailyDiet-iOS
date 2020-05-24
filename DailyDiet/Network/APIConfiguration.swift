
import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var METHOD: HTTPMethod { get }
    var FULL_PATH_URL: String { get }
    var PARAMETERS: Parameters? { get }
}
