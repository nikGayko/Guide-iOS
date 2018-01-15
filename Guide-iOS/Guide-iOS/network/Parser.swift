import Foundation
import ObjectMapper

class Parser {
    
    class func parseSightResponse(json: [String:Any]?) -> [Sight]? {
        guard let json = json else {
            return nil
        }
        
        guard let queryJSON = json["query"] as? [String: Any] else {
            return nil
        }
        
        guard let pagesJSON = queryJSON["pages"] as? [String: Any] else {
            return nil
        }
        
        var sightArray = [Sight]()
        for (key, value) in pagesJSON {
            if let sight = Mapper<Sight>().map(JSONObject: value) {
                sightArray.append(sight)
            }
        }
        
        return sightArray
    }
}
