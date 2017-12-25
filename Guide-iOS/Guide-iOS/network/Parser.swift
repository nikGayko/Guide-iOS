import Foundation
import ObjectMapper

class Parser {
    
    class func parseSightResponse(object: Any) -> [Sight]? {
        guard let json = object as? [String: Any] else {
            return nil
        }
        
        guard let queryJSON = json["query"] as? [String: Any] else {
            return nil
        }
        
        guard let geosearchJSON = queryJSON["geosearch"] else {
            return nil
        }
        
        return Mapper<Sight>().mapArray(JSONObject: geosearchJSON)
    }
}
