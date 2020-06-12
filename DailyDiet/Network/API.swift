
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
    
    static var APIDisposabelRefreshToken: Disposable!
    
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
    
    static func signUP(name: String, email: String, password: String, confirmPassword: String) -> Observable<MessageResponse> {
        return request(URLs.signup(fullName: name, email: email, password: password, confirmPassword: confirmPassword))
    }
    
    static func signOut() -> Observable<EmptyResponse> {
        return request(URLs.signOut)
    }
    
    
    static func refreshToken() -> Observable<Auth> {
        return request(URLs.auth)
    }
    
    static func search(query: String, page:  Int, perPage: Int) -> Observable<Search> {
        return request(URLs.search(text: query, page: page, pageItemCount: perPage))
    }
    
    static func getRecipe(foodID: Int) -> Observable<Recipe> {
        return request(URLs.getRecipe(foodID: foodID))
    }
    
    static func getDiet(mealsCount: Int, calorie: Int, completion: @escaping (([DietClass]) -> Void)) {
        do {
            var url: String = ""
            switch mealsCount {
            case 1:
                url = BaseURL + "/foods/yevade/\(calorie)"
            case 2:
                url = BaseURL + "/foods/dovade/\(calorie)"
            case 3:
                url = BaseURL + "/foods/sevade/\(calorie)"
            default:
                url = ""
            }
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: [NetworkConstant.HTTPHeaderField.authorization : "Bearer \(StoringData.token)"]).responseJSON { (response) -> Void in
                print(response)
                
                switch response.result {
                case .success(let value):
                    var responseArray: [DietClass] = []
                    if let error = value as? [String : String] {
                        DialogueHelper.showStatusBarErrorMessage(message: error["error"] ?? "Not Found")
                        completion(responseArray)
                    } else {
                        if let json = value as? [String: Any] {
                            var diet = json["diet"] as! [Any]
                            diet.removeLast()
                            for i in diet {
                                let decoder = JSONDecoder()
                                let dietString = try! (i as!  NSDictionary).toString()!
                                print("DietString => \(dietString)")
                                let data = dietString.data(using: .utf8)!
                                let dietItem = try! decoder.decode(DietClass.self, from: data)
                                responseArray.append(dietItem)
                            }
                        }
                        completion(responseArray)
                    }
                    
                case .failure( _):
                    API.callRefreshToken()
                    DialogueHelper.showStatusBarErrorMessage(message: "Try Again")
                    completion([])
                }
            }
        } catch {
            Log.e("\(error)")
            completion([])
        }
    }
    
    static func userInfo() -> Observable<UserInfo> {
        return request(URLs.userInfo)
    }
    
    static func blogList() -> Observable<Blog> {
        return request(URLs.blog)
    }
    
    static func blogItem(slug: String) -> Observable<Blog> {
        return request(URLs.blogItem(slug: slug))
    }
    
    static func postBlogItem(category: String, content: String, slug: String, summary: String, title: String)-> Observable<MessageResponse> {
        return request(URLs.postBlogItem(category: category, content: content, slug: slug, summary: summary, title: title))
    }
    
    static func deleteBlogItem(itemID: String) -> Observable<EmptyResponse> {
        return request(URLs.deleteBlogItem(postID: itemID))
    }
    
    static func myBlogPosts() -> Observable<MyBlogItemList> {
        return request(URLs.myBlogItems)
    }
    
    static func callRefreshToken() {
        API.APIDisposabelRefreshToken?.dispose()
        API.APIDisposabelRefreshToken? = API.refreshToken()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("refreshToken => onNext => \(response)")
                DispatchQueue.main.async {
                    StoringData.token = response.accessToken
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("refreshToken => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                DispatchQueue.main.async {
                    StoringData.token = ""
                    StoringData.refreshToken = ""
                    StoringData.isLoggedIn = false
                    DashboardViewController.loginDelegate.updateLoginStatus()
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed to load your data, please login again.")
                }
                
            })
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
                        if response.response?.statusCode == 204 {
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
                                if response.response?.statusCode == 401  {
                                    API.callRefreshToken()
                                } else {
                                    
                                    if let data = response.data {
                                        let responseJSON = try? JSON(data: data)
                                        
                                        observer.onError(NSError(domain: "Error", code: response.response!.statusCode, userInfo: responseJSON?.dictionaryObject))
                                    }
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
