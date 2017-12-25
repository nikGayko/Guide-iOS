import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func toLocation() -> Location {
        return Location(latitude: self.latitude, longtitude: self.longitude)
    }
}
