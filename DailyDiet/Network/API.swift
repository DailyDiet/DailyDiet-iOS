
import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class EmptyResponse: Codable {}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}


class API {
    
    static func bmi(weight: Int, height: Int) -> Observable<Bmi> {
        return request(URLs.calculateBmi(weight: weight, height: height))
    }
    
    static func calculateCalorie(goal: String, gender: String, height: Int, weight: Int, age: Int, activity: String) -> Observable<Calorie> {
        return request(URLs.calculateCalorie(goal: goal, gender: gender, height: height, weight: weight, age: age, activity: activity))
    }
    
    static func changePassword(oldPassword: String, newPassword: String) -> Observable<EmptyResponse> {
        return request(URLs.changePassword(oldPassword: oldPassword, newPassword: newPassword))
    }
    
    static func signIn(email: String, password: String) -> Observable<SignIn> {
        return request(URLs.signIn(email: email, password: password))
    }
    
    static func signUP(name: String, email: String, password: String) -> Observable<MessageResponse> {
        return request(URLs.signup(fullName: name, email: email, password: password))
    }
    
    static func signOut() -> Observable<EmptyResponse> {
        return request(URLs.signOut)
    }
    
    static func refreshToken() -> Observable<Auth> {
        return request(URLs.auth)
    }
    
    static func getRecipe(foodID: Int) -> Observable<Recipe> {
        return request(URLs.getRecipe(foodID: foodID))
    }
    
    static func getDiet(mealsCount: Int, calorie: Int) -> Observable<Diet> {
        return request(URLs.getDiet(mealsCount: mealsCount, calorie: calorie))
    }
    
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        Log.i()
        
        return Observable<T>.create { observer  in
            _ = AF.request(urlConvertible, interceptor: NetworkInterceptor()).validate().responseDecodable
                { (response: DataResponse<T,AFError>) in
                    Log.i("REQUEST => \(String(describing: response.request))")
                    Log.i("STATUS CODE => \(String(describing: response.response?.statusCode))")
                    
                    switch response.result {
                    case .success(let value):
                        Log.i("SUCSESS => VALUE => \(String(describing: value))")
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        if response.response!.statusCode == 204 {
                            observer.onNext(EmptyResponse() as! T)
                            observer.onCompleted()
                        } else {
                        switch error {
                        case .responseSerializationFailed(let reason):
                            if case .inputDataNilOrZeroLength = reason  {
                                observer.onNext(EmptyResponse() as! T)
                                observer.onCompleted()
                            }
                            print(reason)
                            observer.onError(NSError(domain: error.errorDescription ?? "Error", code: response.response!.statusCode, userInfo: nil))
                        default:

                            if let data = response.data {
                                let responseJSON = try? JSON(data: data)
                                
                                observer.onError(NSError(domain: "Error", code: response.response!.statusCode, userInfo: responseJSON?.dictionaryObject))
                            }
                            Log.e("FAILURE => ERROR DESCRIPTION => \(String(describing: error.errorDescription))")
                            observer.onError(error)
                        }
                    }
                    }
            }
            return Disposables.create()
        }
    }
}
