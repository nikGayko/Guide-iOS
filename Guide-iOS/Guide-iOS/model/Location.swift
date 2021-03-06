import Foundation
import ObjectMapper

struct Location: Mappable {
    
    var latitude: Double?
    var longtitude: Double?
    
    init(latitude: Double, longtitude: Double) {
        self.latitude = latitude
        self.longtitude = longtitude
    }
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        let currentKey = map.currentKey ?? ""
        latitude    <- map[currentKey + "lat"]
        longtitude  <- map[currentKey + "lon"]
    }
    
    
    
    
}
