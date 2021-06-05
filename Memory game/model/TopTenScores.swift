import Foundation

class TopTenScores : Codable {
    var scoreArray : [Score] = []
    
    init() {}
    
    
    func sortArray(){
        if (scoreArray.count > 1){
            for i in 0...scoreArray.count-1{
                for j in 0...scoreArray.count-1{
                    if(scoreArray[i].score < scoreArray[j].score){
                        let temp = scoreArray[i]
                        scoreArray[i] = scoreArray[j]
                        scoreArray[j] = temp
                    }
                }
            }
        }
    }
    
    func trimArray(){
        while(scoreArray.count > 10){
            scoreArray.remove(at: scoreArray.count - 1)
        }
    }
}
