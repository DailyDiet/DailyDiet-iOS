
import Foundation
import UIKit
enum UserDefaultKeys:String {
    case hasShownInstructions = "hasShownInstructions"
    case hasLoggedIn = "hasLoggedIn"
    case keyboardDistances = "keyboardDistance"
    case refreshToken = "RefreshToken"
    case token = "Token"
}
class StoringData {
    static var hasShownInstructions:Bool {
        get{
            return UserDefaults.standard.bool(forKey: UserDefaultKeys.hasShownInstructions.rawValue)
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.hasShownInstructions.rawValue)
        }
    }
    
    static var refreshToken: String {
        get{
            return UserDefaults.standard.string(forKey: UserDefaultKeys.refreshToken.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.refreshToken.rawValue)
        }
    }
    
    static var token: String {
        get{
            return UserDefaults.standard.string(forKey: UserDefaultKeys.token.rawValue) ?? ""
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.token.rawValue)
        }
    }
    
    static var isLoggedIn:Bool {
        get{
            return UserDefaults.standard.bool(forKey: UserDefaultKeys.hasLoggedIn.rawValue)
        }
        set (newValue){
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.hasLoggedIn.rawValue)
        }
    }
    static var keyboardDistances:[String:Any]? {
        get {
            return UserDefaults.standard.dictionary(forKey: UserDefaultKeys.keyboardDistances.rawValue)
        }
        set (newValue) {
            if let dictionary =  UserDefaults.standard.dictionary(forKey: UserDefaultKeys.keyboardDistances.rawValue) {
                var changedDictionary = dictionary
                changedDictionary["\(newValue!.keys.first!)"] = newValue!.values.first!
                UserDefaults.standard.setValue(changedDictionary, forKey: UserDefaultKeys.keyboardDistances.rawValue)
            }else{
                UserDefaults.standard.setValue(newValue!, forKey:UserDefaultKeys.keyboardDistances.rawValue )
            }
            
        }
    }
}
