import Foundation
import Alamofire
import SwiftyBeaver

class HttpClient {
    typealias JSONCallback = ([String: Any]?) -> Void
    typealias ImageCallback = (UIImage?) -> Void
    typealias DataCallback = (Data?) -> Void
    
    static func loadJSON(url: String, callback: @escaping JSONCallback) {
        loadData(url: url) { data in
            guard let data = data else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                callback(json)
            } else {
                SwiftyBeaver.warning("Couldn't cast data to json")
                callback(nil)
            }
        }
    }
    
    static func loadImage(url: String, callback: @escaping ImageCallback) {
        loadData(url: url) { data in
            guard let data = data else { return }
            
            if let image = UIImage(data: data) {
                callback(image)
            } else {
                SwiftyBeaver.warning("Couldn't cast data to image")
                callback(nil)
            }
        }
    }
    
    static func loadData(url: String, callback: @escaping DataCallback) {
        Alamofire.request(url).validate().responseData { response in
            switch response.result {
                
            case .success(let data):
                callback(data)
                
            case .failure(let error):
                SwiftyBeaver.error(error)
                callback(nil)
            }
        }
    }
}
