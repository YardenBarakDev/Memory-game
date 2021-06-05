import UIKit
import GoogleMaps

class ScoreController: UIViewController  {
    
    @IBOutlet weak var score_map: GMSMapView!
    @IBOutlet weak var score_TableView: UITableView!
    
    let locationManager = CLLocationManager()
    var topTen : TopTenScores?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setLocationManager()
        setTableView()
        getTopTenScores()
    }
    
    private func setTableView(){
        //set table view
        score_TableView.delegate = self
        score_TableView.dataSource = self
        score_TableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreTableViewCell")
        
    }
    
    private func setLocationManager(){
        //set map delegate
        locationManager.delegate = self
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestLocation()
        }
        else{
            locationManager.requestWhenInUseAuthorization()
        }

       
    }
    
    func getTopTenScores(){
        topTen = DataManagment().getSavedScoreArray()
        
        if let scoreArray = topTen{
            scoreArray.sortArray()
            scoreArray.trimArray()
            
            var place = 1
            for score in scoreArray.scoreArray{
                addMarker(score: score, place: place)
                place += 1
            }
        }
        //update tableView data
        score_TableView.reloadData()
    }
}


extension ScoreController : UITableViewDelegate{
    
    //cell onClick
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let array = topTen{
            showLocationOnTheMap(lat: array.scoreArray[indexPath.row].lat,lon: array.scoreArray[indexPath.row].lon)
        }
    }
    
}

extension ScoreController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTen?.scoreArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = score_TableView.dequeueReusableCell(withIdentifier: "ScoreTableViewCell", for: indexPath) as! ScoreTableViewCell
        
        cell.scoreCell_name.text = topTen?.scoreArray[indexPath.row].name
        cell.scoreCell_score.text = "\(topTen?.scoreArray[indexPath.row].score ?? 100)"
        cell.scoreCell_date.text = topTen?.scoreArray[indexPath.row].date
        cell.scoreCell_place.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 105
    }
}

extension ScoreController : CLLocationManagerDelegate{
    
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

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func addMarker(score : Score, place : Int){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: score.lat, longitude: score.lon)
        marker.title = "\(place)st"
        marker.snippet = score.name
        marker.map = score_map
    }
    
    func showLocationOnTheMap(lat : Double, lon : Double){
        score_map.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                             zoom: 8,
                                             bearing: 0,
                                             viewingAngle: 0)
    }
}
