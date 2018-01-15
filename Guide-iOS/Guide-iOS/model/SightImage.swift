import Foundation
import ObjectMapper

struct SightImage: Mappable {
    var height: Int64?
    var width: Int64?
    var sourceURL: String?
    var image: UIImage?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        let currentKey = map.currentKey ?? ""
        height      <- map[currentKey + "height"]
        width       <- map[currentKey + "width"]
        sourceURL   <- map[currentKey + "source"]
    }
    
}
