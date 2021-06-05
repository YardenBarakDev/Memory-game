import Foundation

class Score : Codable{
    
    var name : String = ""
    var score : Int = -1
    var date : String = ""
    var lat : Double = 0
    var lon : Double = 0
    
    init(name: String, score: Int, date: String, lat: Double, lon: Double) {
        self.name = name
        self.score = score
        self.date = date
        self.lat = lat
        self.lon = lon
    }
    
    init() {}
    
}
