
import Foundation
import Alamofire

class NetworkInterceptor: Interceptor {

    // MARK: - RequestRetrier
    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        Log.e("\(error)")
        Log.e("REQUEST RETRY COUNT => \(request.retryCount)")
        Log.e("REQUEST URL => \(String(describing: request.request?.url))")

        if (request.retryCount > 5)
        {
            Log.e("REQUEST RETRIED 5 TIMES")
            completion(.doNotRetry)
        }
        else
        {
            if let afError = error.asAFError
            {
                Log.e("THIS IS ALAMOFIRE ERROR")
                if afError.isSessionTaskError
                {
                    Log.e("SESSION TASK ERROR")
                    completion(.retryWithDelay(TimeInterval(5)))
                }
                else if let response = request.task?.response as? HTTPURLResponse
                {
                    Log.e("RESPONSE CODE => \(response.statusCode)")
                    if response.statusCode == 500
                    {
                        Log.e("SERVER UNAVAILABLE ERROR")
                        completion(.retry)
                    }
                    else
                    {
                        Log.e("THIS IS NOT SERVER UN AVAILABLE")
                        completion(.doNotRetry)
                    }
                }
                else
                {
                    Log.e("REQUEST IS NOT HTTP URL RESPONSE")
                    completion(.doNotRetry)
                }

            }

            else if let response = request.task?.response as? HTTPURLResponse
            {
                Log.e("RESPONSE CODE => \(response.statusCode)")
                if response.statusCode == 500
                {
                    Log.e("SERVER UNAVAILABLE ERROR")
                    completion(.retry)
                }
            }
            else
            {
                Log.e("REQUEST IS NOT HTTP URL RESPONSE")
                completion(.doNotRetry)
            }
        }
    }
}
