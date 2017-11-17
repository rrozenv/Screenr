
import Foundation
import CoreLocation
import PromiseKit

protocol LocationServiceDelegate: class {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

final class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationService()
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else { return }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200 //meters
        locationManager.delegate = self
    }
    
    func requestSingleLocation() {
        print("Requesting single location")
        self.locationManager?.requestLocation()
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func fetchPostalCodeFor(_ location: CLLocation) -> Promise<String?> {
        return Promise { fullfill, reject in
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error { reject(error) }
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    fullfill(placemark.postalCode ?? nil)
                } else {
                    fullfill(nil)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.requestSingleLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    private func updateLocation(currentLocation: CLLocation){
        guard let delegate = self.delegate else { return }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        guard let delegate = self.delegate else { return }
        delegate.tracingLocationDidFailWithError(error: error)
    }

}
