import Foundation
import ObjectMapper

class Sight: Mappable {
    
    var pageID: Int64?
    var ns: Int64?
    var title: String?
    var location: Location?
    var distance: Double?
    var thumbnailImage: SightImage?
    var originImage: SightImage?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        pageID          <- map["pageid"]
        ns              <- map["ns"]
        title           <- map["title"]
        distance        <- map["dist"]
        
        location        = Location(map: map["coordinates.0."])
        thumbnailImage  = SightImage(map: map["thumbnail."])
        originImage     = SightImage(map: map["original."])
    }
    
}
