import Foundation
import SwiftyBeaver
import Alamofire
import ObjectMapper

class WikipediaAPI {

    public class func getNearbySights(location: Location, radius: Int, responseCount: Int? = nil, callback: (([Sight]?, Bool) -> Void)? = nil) {
        
        var builder = URLBuilder(action: "query", format: "json", list: "geosearch")
            .buildCoord(location)
            .buildRadius(radius)
        
        if let responseCount = responseCount {
            builder = builder.buildLimit(responseCount)
        }

        guard let url = builder.getURL().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            SwiftyBeaver.error("Encoding fail")
            return
        }
        
        SwiftyBeaver.info(url)
        
        
        Alamofire.request(url).validate().responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let json):
                SwiftyBeaver.info(json)

                let sightArray = Parser.parseSightResponse(object: json)
                callback?(sightArray, true)
                
            case .failure(let error):
                SwiftyBeaver.error(error)
                callback?(nil, false)
            }
        })
        
    }
    
}
