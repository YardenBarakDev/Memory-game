import Foundation

class DataManagment{
    
    func getSavedScoreArray() -> TopTenScores{
        var topTen : TopTenScores?
        let topTenJson : String? = UserDefaults.standard.string(forKey: Constants.scoreArray)
        if let safeTopTen = topTenJson{
            let decoder = JSONDecoder()
            let data = Data(safeTopTen.utf8)
            do{
                topTen = try decoder.decode(TopTenScores.self, from: data)
            }catch{}
        }
        return topTen ?? TopTenScores()
    }
    
    func saveScoreArray(topTenScores : TopTenScores){
        let encoder = JSONEncoder()
        let data = try! encoder.encode(topTenScores)
        let scores : String = String(data: data, encoding: .utf8)!
        UserDefaults.standard.setValue(scores, forKey: Constants.scoreArray)
    }
}
