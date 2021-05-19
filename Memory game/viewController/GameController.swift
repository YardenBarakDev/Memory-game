import UIKit

class GameController : UIViewController {

    //ui variable
    @IBOutlet weak var game_Timer: UILabel!
    @IBOutlet weak var game_movesCounter: UILabel!
    @IBOutlet weak var game_collectionView: UICollectionView!
    
    //game variable
    var numOfMoves : Int = 0
    var choiceNumber : Int = 0
    var matches : Int = 0
    var previousIndex : Int = -1
    var timer : Timer?
    var firstChoice : MyCollectionViewCell!
    var secondChoice : MyCollectionViewCell!
    var timerSeconds = 0
    var timerMinutes = 0
    var dataSource : [String] =
        ["twitter", "twitter", "facebook", "facebook", "google_plus", "google_plus", "youtube", "youtube",
         "instagram", "instagram", "linkedin", "linkedin", "paypal", "paypal", "skype", "skype"]
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.shuffle() //suffale Array
        setCollectionView()
        startTimer();
        
        //start timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }

    func setCollectionView(){
    
        game_collectionView.isScrollEnabled = false
        game_collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        game_collectionView.delegate = self
        game_collectionView.dataSource = self
        
    }
    
   @objc func startTimer(){
    
    if (timerSeconds == 59) {
        timerMinutes += 1
        timerSeconds = 0
    }
    else{
        timerSeconds += 1
    }
    if (timerMinutes < 10 && timerSeconds < 10) {
        game_Timer.text = "0\(timerMinutes):0\(timerSeconds)"
    }
    else if (timerMinutes >= 10 && timerSeconds < 10) {
        game_Timer.text = "\(timerMinutes):0\(timerSeconds)"
    }
    else if (timerMinutes < 10 && timerSeconds >= 10) {
        game_Timer.text = "0\(timerMinutes):\(timerSeconds)"
    }
    else if (timerMinutes >= 10 && timerSeconds >= 10) {
        game_Timer.text = "\(timerMinutes):\(timerSeconds)"
    }
   }

   @objc func check(){
    
        if(checkMatch()){
            matches += 1
        }
        else {
            flipCardsBack()
        }
        updateMovesCounter()
        if(matches != dataSource.count/2){
            previousIndex = -1 //allow the user to choose 2 cards again
            choiceNumber = 0
        }
        else{
            timer?.invalidate() //stop timer
            print("Done!")
            saveData()
        }
    }
    func checkMatch () -> Bool{
        return firstChoice.imageView.image == secondChoice.imageView.image
    }
    
    func flipCardsBack(){
        firstChoice.setImage(with: UIImage(named: "card")!)
        secondChoice.setImage(with: UIImage(named: "card")!)
    }
    
    func updateMovesCounter(){
        numOfMoves += 1
        game_movesCounter.text = "\(numOfMoves)"
    }
    
    func saveData(){
        UserDefaults.standard.set(numOfMoves, forKey: Constants.moves) //number of moves
        UserDefaults.standard.set(game_Timer.text, forKey: Constants.time) //timer time
    }
}


extension GameController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (previousIndex == -1) {
            previousIndex = indexPath.row
            choiceNumber += 1
            firstChoice = game_collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell
            firstChoice.setImage(with: UIImage(named: dataSource[indexPath.row])!)
        }
        else if(previousIndex != indexPath.row && choiceNumber == 1){
            choiceNumber += 1
            secondChoice = game_collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell
            secondChoice.setImage(with: UIImage(named: dataSource[indexPath.row])!)
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(check), userInfo: nil, repeats: false)
        }
    }
}

extension GameController : UICollectionViewDataSource{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numOfCards : Int = UserDefaults.standard.integer(forKey: Constants.numOfCards) 
        return numOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = game_collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        
        cell.setImage(with: UIImage(named: "card")!)
        return cell
    }
    
}

extension GameController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: game_collectionView.frame.width/4, height: game_collectionView.frame.height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
