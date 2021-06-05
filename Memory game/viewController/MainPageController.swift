
import UIKit
import GoogleMaps

class MainPageController: UIViewController {

    
    @IBOutlet weak var main_playEasy: MyCostumButton!
    @IBOutlet weak var main_playHard: MyCostumButton!
    @IBOutlet weak var main_topTen: MyCostumButton!
    
    let locationManager = CLLocationManager()
    var locationMethos : LocationMethods?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationMethos = LocationMethods(locationManager: locationManager)
        if let permission = locationMethos{
            permission.askLocationPermission()
        }
    }
    
    func openSettings(){
        let alertController = UIAlertController (title: Constants.settingsTitle, message: Constants.settingsMessage, preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func main_playEasyClick(_ sender: Any) {
        
        if let permission = locationMethos{
            if(!permission.isLoctionPermissionEnabled()){
                openSettings()
            }
            else{
                UserDefaults.standard.setValue(16, forKey: Constants.numOfCards)
                UserDefaults.standard.setValue(4, forKey: Constants.rows)
                let vc = storyboard?.instantiateViewController(identifier: "GameController") as! GameController
                vc.modalTransitionStyle = .flipHorizontal
                //vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func main_playHardClick(_ sender: Any) {
        if let permission = locationMethos{
            if(!permission.isLoctionPermissionEnabled()){
                openSettings()
            }
            else{
            UserDefaults.standard.setValue(20, forKey: Constants.numOfCards)
            UserDefaults.standard.setValue(5, forKey: Constants.rows)
            let vc = storyboard?.instantiateViewController(identifier: "GameController") as! GameController
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func main_topTenClick(_ sender: Any) {
        if let permission = locationMethos{
            if(!permission.isLoctionPermissionEnabled()){
                openSettings()
            }
            else{
            let vc = storyboard?.instantiateViewController(identifier: "ScoreController") as! ScoreController
            vc.modalTransitionStyle = .flipHorizontal
            //vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            }
        }
    }
}


extension MainPageController : CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latitude = locationManager.location?.coordinate.latitude ?? 0.0
        let longitude = locationManager.location?.coordinate.longitude ?? 0.0
        
        print("lon = \(longitude), lat = \(latitude)")
        UserDefaults.standard.setValue(latitude, forKey: Constants.latitude)
        UserDefaults.standard.setValue(longitude, forKey: Constants.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
