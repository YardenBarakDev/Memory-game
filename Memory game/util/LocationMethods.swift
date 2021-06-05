
import Foundation
import UIKit
import GoogleMaps

class LocationMethods{
    
    let locationManager : CLLocationManager
    
    init(locationManager : CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func askLocationPermission(){
   
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestLocation()
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func isLoctionPermissionEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
                @unknown default:
                break
                    
            }
        }
        return false
    }
}
