

import Foundation
import Alamofire


let BaseURL = "dailydiet-api.herokuapp.com"

enum URLs: APIConfiguration {
    
    case bmi(weight: Int, height: Int)

    var METHOD: HTTPMethod {
        switch self {
        case .bmi:
            return .post
        default:
            return .get
        }
    }

    var FULL_PATH_URL: String {
        switch self {
            
        }
    }

    var PARAMETERS: Parameters?
    {
        switch self {
        case .bmi(let weight,let height: <#T##Int#>)
            return [NetworkConstant.APIParameterKey.ConfirmEmail.email : email]
        case .confirmEmailAddressForResetPassword(let email):
            return [NetworkConstant.APIParameterKey.ConfirmEmail.email : email]
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
        case .login(let username, let password):
            let json: [String: String] = [
                "Grant_Type" : "password",
                "UserName" : username,
                "Password" : password,
                "Client_id" : "Catalog",
                "Client_secret" : "db258e47-@WSX-47b7-1qaz-91033ba08e7d"
            ]
            Log.i("HTTP Body =>  \(json)")
            let data = "UserName=\(username)&Password=\(password)&Grant_Type=password&Client_id=Catalog&Client_secret=db258e47-@WSX-47b7-1qaz-91033ba08e7d".data(using: .utf8)!
            urlRequest.httpBody = data
//            do {
//                urlRequest.httpBody = data
//            } catch let error {
//                Log.e(error.localizedDescription)
//            }
        case .changePassword(let userName, let oldPassword, let newPassword, let confirmNewPassword):
            let json: [String: Any] = [
                NetworkConstant.APIBodyKey.ChangePassword.username : userName,
                NetworkConstant.APIBodyKey.ChangePassword.oldPassword : oldPassword,
                NetworkConstant.APIBodyKey.ChangePassword.newPassword : newPassword,
                NetworkConstant.APIBodyKey.ChangePassword.confirmPassword : confirmNewPassword
            ]
            Log.i("HTTP Body =>  \(json)")

            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch let error {
                Log.e(error.localizedDescription)
            }

        case .resetPassword(let userName, let password, let confirmPassword, let code):
            let json: [String: Any] = [
                NetworkConstant.APIBodyKey.ResetPassword.username : userName,
                NetworkConstant.APIBodyKey.ResetPassword.verifyCode : code,
                NetworkConstant.APIBodyKey.ResetPassword.newPassword : password,
                NetworkConstant.APIBodyKey.ResetPassword.confirmPassword : confirmPassword
            ]
            Log.i("HTTP Body =>  \(json)")

            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch let error {
                Log.e(error.localizedDescription)
            }
        case .registerCompany(let password, let confirmPassword, let companyEmail, let companyName, let phoneNumber, let confirmCode):
            let json: [String: Any] = [
                NetworkConstant.APIBodyKey.RegisterCompany.password : password,
                NetworkConstant.APIBodyKey.RegisterCompany.confirmPassword : confirmPassword,
                NetworkConstant.APIBodyKey.RegisterCompany.companyEmail : companyEmail,
                NetworkConstant.APIBodyKey.RegisterCompany.companyName : companyName,
                NetworkConstant.APIBodyKey.RegisterCompany.phoneNumber : phoneNumber,
                NetworkConstant.APIBodyKey.RegisterCompany.confirmCode : confirmCode,
            ]
            Log.i("HTTP Body =>  \(json)")

            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
            } catch let error {
                Log.e(error.localizedDescription)
            }
//        case .getCompanyInfo:
//            let json: [String: Any] = [
//                NetworkConstant.APIBodyKey.GetCompanyInfo.accept : NetworkConstant.APIBodyValue.GetCompanyInfo.textPlain
//            ]
//            Log.i("HTTP Body =>  \(json)")
//
//            do {
//                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: json)
//            } catch let error {
//                Log.e(error.localizedDescription)
//            }
        default:
            break
        }

        let token: String = UserDefaultsHelper.get(key: .token) ?? ""
        switch self {
        case .login:
//            urlRequest.allHTTPHeaderFields = [NetworkConstant.HTTPHeaderField.contentType : NetworkConstant.ContentType.urlencoded]
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: NetworkConstant.HTTPHeaderField.contentType)
        case .changePassword:
            urlRequest.setValue(NetworkConstant.APIBodyValue.ChangePassword.applicationJsonPatch , forHTTPHeaderField: NetworkConstant.APIBodyKey.ChangePassword.contentType)
            urlRequest.setValue(NetworkConstant.APIBodyValue.ChangePassword.applicatioJson, forHTTPHeaderField: NetworkConstant.APIBodyKey.ChangePassword.accept)
            urlRequest.setValue(token, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.authorization)
        case .resetPassword:
            urlRequest.setValue(NetworkConstant.APIBodyValue.ChangePassword.applicationJsonPatch , forHTTPHeaderField: NetworkConstant.APIBodyKey.ChangePassword.contentType)
            urlRequest.setValue(NetworkConstant.APIBodyValue.ChangePassword.applicatioJson, forHTTPHeaderField: NetworkConstant.APIBodyKey.ChangePassword.accept)
        case .getCompanyInfo:
            urlRequest.setValue(token, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.authorization)
        case .getSubscriptionConfigAsync:
            urlRequest.setValue(token, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.authorization)
        default:
            urlRequest.setValue(NetworkConstant.ContentType.json, forHTTPHeaderField: NetworkConstant.HTTPHeaderField.contentType)
        }

        
        urlRequest.httpMethod = METHOD.rawValue


        Log.i("Request => \(urlRequest)")
        Log.i("Request All Headers => \(urlRequest.allHTTPHeaderFields!)")
        
        return urlRequest

   }
}
