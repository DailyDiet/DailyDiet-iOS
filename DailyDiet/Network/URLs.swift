

import Foundation
import Alamofire


let BaseURL = "https://dailydiet-api.herokuapp.com"

enum URLs: APIConfiguration {
    
    case calculateBmi(weight: Int, height: Int)
    case calculateCalorie(goal: String, gender: String, height: Int, weight: Int, age: Int, activity: String)
    case signup(fullName: String, email: String, password: String, confirmPassword: String)
    case confirmSignup
    case signIn(email: String, password: String)
    case auth
    case resendConfirmationLink
    case changePassword(oldPassword: String, newPassword: String)
    case signOut
    case userInfo
    case getRecipe(foodID: Int)
    case foodInfo(foodID: Int)
    case getDiet(mealsCount: Int, calorie: Int)
    case search(text: String, page: Int, pageItemCount: Int)
    case blog
    case blogItem(slug: String)
    case postBlogItem(category: String, content: String, slug: String, summary: String, title:  String)
    case deleteBlogItem(postID: String)
    case myBlogItems
    
    var METHOD: HTTPMethod {
        switch self {
        case .confirmSignup, .resendConfirmationLink, .getRecipe, .foodInfo, .getDiet, .search, .userInfo, .blog, .blogItem, .myBlogItems:
            return .get
        case .auth:
            return .put
        case .deleteBlogItem:
            return .delete
        case .changePassword, .signOut:
            return .patch
        default:
            return .post
        }
    }
    
    var FULL_PATH_URL: String {
        switch self {
        case .calculateBmi:
            return BaseURL + "/calculate/bmi"
        case .calculateCalorie:
            return BaseURL + "/calculate/calorie"
        case .signup:
            return BaseURL + "/users/signup"
        case .confirmSignup:
            return BaseURL + "/users/signup/confirmation/\(StoringData.token)"
        case .signIn:
            return BaseURL + "/users/signin"
        case .auth:
            return BaseURL + "/users/auth"
        case .resendConfirmationLink:
            return BaseURL + "/users/signup/resendConfrimation"
        case .changePassword:
            return BaseURL + "/users/signup/modify"
        case .signOut:
            return BaseURL + "/users/signout"
        case .userInfo:
            return BaseURL + "/users/get_user"
        case .getRecipe(let foodID):
            return BaseURL + "/foods/recipe/\(foodID)"
        case .foodInfo(let foodID):
            return BaseURL + "/foods/\(foodID)"
        case .getDiet(let mealsCount,  let calorie):
            switch mealsCount {
            case 1:
                return BaseURL + "/foods/yevade/\(calorie)"
            case 2:
                return BaseURL + "/foods/dovade/\(calorie)"
            case 3:
                return BaseURL + "/foods/sevade/\(calorie)"
            default:
                return ""
            }
        case .search:
            return BaseURL + "/foods/search"
        case .blog:
            return BaseURL + "/blog/"
        case .blogItem(let slug):
            return BaseURL + "/blog/\(slug)"
        case .postBlogItem:
            return BaseURL + "/blog/posts/new/"
        case .deleteBlogItem(let postID):
            return BaseURL + "/posts/delete/\(postID)"
        case .myBlogItems:
            return BaseURL + "/blog/posts/user"
        }
    }
    
    var PARAMETERS: Parameters?
    {
        switch self {
        case .search(let text, let page, let pageItemCount):
            return [
                NetworkConstant.APIParameterKey.Search.query : text,
                NetworkConstant.APIParameterKey.Search.page : page,
                NetworkConstant.APIParameterKey.Search.perPage : pageItemCount
            ]
        default:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var urlRequest = URLRequest(url: try FULL_PATH_URL.asURL())
        var urlComponents = URLComponents(string: "\(urlRequest)")
        
        if let parameters = PARAMETERS {
            var param = [URLQueryItem]()
            parameters.keys.forEach({ (key) in param.append(URLQueryItem(name: key, value: "\(parameters[key]!)")) })
            urlComponents?.queryItems = param.reversed()
            
        }
        
        urlRequest = URLRequest(url: (urlComponents?.url)!)
        
        switch self {
        case .calculateBmi(let weight, let height):
            urlRequest.httpBody = "height=\(height)&weight=\(weight)".data(using: .utf8)!
        case .calculateCalorie(let goal, let gender, let height, let weight, let age, let activity):
            urlRequest.httpBody = "goal=\(goal)&gender=\(gender)&height=\(height)&weight=\(weight)&age=\(age)&activity=\(activity)".data(using: .utf8)!
        case .signup(let fullName, let email, let password, let confirmPassword):
            urlRequest.httpBody = "full_name=\(fullName)&email=\(email)&password=\(password)&confirm_password=\(confirmPassword)".data(using: .utf8)!
        case .signIn(let email, let password):
            urlRequest.httpBody = "email=\(email)&password=\(password)".data(using: .utf8)!
        case .changePassword(let oldPassword, let newPassword):
            urlRequest.httpBody = "old_password=\(oldPassword)&new_password=\(newPassword)&confirm_password=\(newPassword)".data(using: .utf8)!
        case .postBlogItem(let category, let content , let slug, let summary, let title):
            urlRequest.httpBody = "category=\(category)&content=\(content)&slug=\(slug)&summary=\(summary)&title=\(title)".data(using: .utf8)!
        default:
            break
        }
        
        
        switch self {
        case .auth:
            urlRequest.setValue("Bearer \(StoringData.refreshToken)", forHTTPHeaderField: NetworkConstant.HTTPHeaderField.authorization)
        case .signIn, .signup, .calculateCalorie, .calculateBmi:
            urlRequest.setValue(NetworkConstant.ContentType.urlencoded, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.contentType)
        case .changePassword:
            urlRequest.setValue(NetworkConstant.ContentType.urlencoded, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.contentType)
            urlRequest.setValue("Bearer \(StoringData.token)", forHTTPHeaderField: NetworkConstant.HTTPHeaderField.authorization)
        case .blog,  .blogItem:
            break
        default:
            urlRequest.setValue("Bearer \(StoringData.token)", forHTTPHeaderField: NetworkConstant.HTTPHeaderField.authorization)
        }
        
        
        urlRequest.httpMethod = METHOD.rawValue
        
        
        Log.i("Request => \(urlRequest)")
        Log.i("Request All Headers => \(urlRequest.allHTTPHeaderFields!)")
        
        return urlRequest
        
    }
}
