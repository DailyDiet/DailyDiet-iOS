

import Foundation
import SwiftyBeaver

class Log {
    
    static let log = SwiftyBeaver.self
    
    static var isActive: Bool = true


    static func i(callingFunctionName: String = #function, callingClassName: String = #file,_ messsage: String = "", file: Any? = nil){
        if self.isActive{
            if let file = file {
                 Log.log.debug("\((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage, context: file)
             } else {
                 Log.log.debug("\((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage)
             }
        }
    }



    static func e(callingFunctionName: String = #function, callingClassName: String = #file,_ messsage: String = "", file: Any? = nil)  {
        if self.isActive{
            if let file = file {
                Log.log.error("\((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage, context: file)
            } else {
                Log.log.error("\((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage)
            }
        }
    }

    static func w(callingFunctionName: String = #function, callingClassName: String = #file,_ messsage: String = "", file: Any? = nil)  {
        if self.isActive{
            if let file = file {
                 Log.log.warning("\((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage, context: file)
             } else {
                 Log.log.warning("\((callingClassName as NSString).lastPathComponent) - \(callingFunctionName)" + " => " + messsage)
             }
        }
    }
}
