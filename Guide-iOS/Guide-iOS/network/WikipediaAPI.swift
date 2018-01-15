import Foundation
import SwiftyBeaver
import ObjectMapper

enum WikipediaAPIOptions {
    case radius(Int)
    case responseCount(Int)
    case thumbnail(Int)
    case original
}

class WikipediaAPI {
    static let maxRadius = WikipediaAPIOptions.radius(10000)
    static let maxResponse = WikipediaAPIOptions.responseCount(500)
    
    public class func getNearbySights(location: Location, options: [WikipediaAPIOptions]? = nil, callback: @escaping ([Sight]?) -> Void) {
        var builder = URLBuilder(action: "query", format: "json", generator: "geosearch")
            .buildCoord(location)
            .buildProp("pageimages")
            .buildProp("coordinates")
        
        if let options = options {
            builder = builder.buildWithOptions(options)
        }

        guard let url = builder.getURL().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            SwiftyBeaver.error("Encoding fail")
            callback(nil)
            return
        }
        
        SwiftyBeaver.info(url)
        
        HttpClient.loadJSON(url: url, callback: { json in
            let sightArray = Parser.parseSightResponse(json: json)
        })
    }
    
}
