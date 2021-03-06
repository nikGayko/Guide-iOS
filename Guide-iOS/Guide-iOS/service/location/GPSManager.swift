import Foundation
import CoreLocation
import SwiftyBeaver

final class GPSManager: NSObject, CLLocationManagerDelegate {
    private static var instance: GPSManager?
    
    public static func sharedInstance() -> GPSManager {
        if instance == nil {
            instance = GPSManager()
        }
        return instance!
    }
    
    private var locationManager: CLLocationManager?
    private var eventListener: GPSEventListener?
    
    private override init() {
        super.init()
        
        locationManager = CLLocationManager()
        setupLocationManager()
    }
    
    func setupLocationManager() {
        guard let locationManager = locationManager else {
            SwiftyBeaver.warning("Location manager is nil")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func startMonitoringChanges() {
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringChanges() {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopMonitoringSignificantLocationChanges()
    }
    
    func subscribeForEvents(_ eventListener: GPSEventListener) {
        self.eventListener = eventListener
    }
    
    func unsubscribeFromEvents() {
        self.eventListener = nil
    }
    
    //MARK: locationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        eventListener?.locationDidChange(locations[0].coordinate.toLocation())
    }
}
