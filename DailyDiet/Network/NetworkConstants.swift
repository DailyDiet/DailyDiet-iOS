
import Foundation

struct NetworkConstant {



    struct HTTPHeaderField {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
    }
    
    struct APIParameterKey{
        struct Search {
            static let query = "query"
            static let page = "page"
            static let perPage = "per_page"
        }
    }

    struct APIBodyKey{

    }

    struct APIBodyValue{
        
    }

    struct ContentType {
        static let json = "application/json"
        static let urlencoded = "application/x-www-form-urlencoded"
        static let textPlain = "text/plain"
    }

}
