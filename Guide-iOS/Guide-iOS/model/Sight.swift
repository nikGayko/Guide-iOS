import Foundation
import ObjectMapper

struct Sight: Mappable {
    
    var pageID: Int64?
    var ns: Int64?
    var title: String?
    var location: Location?
    var distance: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        pageID      <- map["pageid"]
        ns          <- map["ns"]
        title       <- map["title"]
        distance    <- map["dist"]
        location    = Location(map: map)
    }
    
}
