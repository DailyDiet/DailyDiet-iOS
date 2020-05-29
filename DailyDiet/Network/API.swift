
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
    
    static func changePassword(oldPassword: String, newPassword: String) -> Observable<EmptyResponse> {
        return request(URLs.changePassword(oldPassword: oldPassword, newPassword: newPassword))
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
            return Disposables.create()
        }
    }
}
