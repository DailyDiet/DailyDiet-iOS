
import Foundation
import UIKit
enum TimeType {
    case Day, Minute, Hour
}


/// This class used for getting Farsi words and sentences
class StringHelper {
    
    class func getMonthName(monthNumber: Int) ->  String {
        switch monthNumber {
        case 1:
            return "فروردین"
        case 2:
            return "اردیبهشت"
        case 3:
            return "خرداد"
        case 4:
            return "تیر"
        case 5:
            return "مرداد"
        case 6:
            return "شهریور"
        case 7:
            return "مهر"
        case 8:
            return "آبان"
        case 9:
            return "آذر"
        case 10:
            return "دی"
        case 11:
            return "بهمن"
        case 12:
            return "اسفند"
        default:
            return ""
        }
    }
    
    
    class func getDayName(day: Int, language: String = "FA") -> String{
        if language == "FA" {
            switch day {
            case 0:
                return "شنبه"
            case 1:
                return "یکشنبه"
            case 2:
                return "دوشنبه"
            case 3:
                return "سه‌شنبه"
            case 4:
                return "چهارشنبه"
            case 5:
                return "پنجشنبه"
            case 6:
                return "جمعه"
            default:
                return "Error"
            }
            
        } else {
            switch day {
            case 0:
                return "Saturday"
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            default:
                return "Error"
            }
        }
        
    }
    
    
}
