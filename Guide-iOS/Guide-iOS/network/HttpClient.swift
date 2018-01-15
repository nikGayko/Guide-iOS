import Foundation
import Alamofire
import SwiftyBeaver

class HttpClient {
    typealias JSONCallback = ([String: Any]?) -> Void
    typealias ImageCallback = (UIImage?) -> Void
    
    static func loadJSON(url: String, callback: @escaping JSONCallback) {
        Alamofire.request(url).validate().responseJSON(completionHandler: { response in
            switch response.result {
                
            case .success(let result):
                SwiftyBeaver.info("\(result)")
                if let json = result as? [String: Any] {
                    callback(json)
                } else {
                    callback(nil)
                }

            case .failure(let error):
                SwiftyBeaver.error(error)
                callback(nil)
            }
        })
    }
    
    static func loadImage(url: String, callback: ImageCallback) {
        
    }
}
