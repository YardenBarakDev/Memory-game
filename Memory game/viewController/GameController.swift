 import UIKit
 import GoogleMaps
 
 class GameController : UIViewController {
    
    //ui variable
    @IBOutlet weak var game_Timer: UILabel!
    @IBOutlet weak var game_movesCounter: UILabel!
    @IBOutlet weak var game_collectionView: UICollectionView!
    
    
    //game variable
    var userName : UITextField!
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
         "instagram", "instagram", "linkedin", "linkedin", "paypal", "paypal", "skype", "skype",
         "spotify", "spotify", "whatsapp", "whatsapp"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSourceAccordingToDifficulty()
        setCollectionView()
        //start timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        
    }
    
    func setDataSourceAccordingToDifficulty(){
        let numOfCards : Int = UserDefaults.standard.integer(forKey: Constants.numOfCards)
        if (numOfCards == 16) {
            for _ in 0...3 {
                dataSource.remove(at: 0)
            }
        }
        dataSource.shuffle() //suffale Array
    }
    
    func setCollectionView(){
        game_collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        game_collectionView.isScrollEnabled = false
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
            showInputAlert()
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
    
    @objc private func showInputAlert(){
        
        //create alert
        let alert = UIAlertController(title: Constants.alertTitle,
                                      message: Constants.alertMessage
                                      , preferredStyle: .alert)
        //add field
        alert.addTextField{field in
            field.placeholder = Constants.alertPlaceholder
            field.returnKeyType = .continue
        }
        //add action
        alert.addAction(UIAlertAction(title: Constants.alertButtonText,
                                      style: .default, handler: {_ in
                                        //read text value
                                        guard let field = alert.textFields, field.count == 1 else{
                                            print("error")
                                            return
                                        }
                                        let input = field[0]
                                        guard let userInput = input.text, !userInput.isEmpty else{
                                            self.saveData(userInput: Constants.alertDefaultInput)
                                            return
                                        }
                                        self.saveData(userInput: userInput)
                                      }))
        present(alert, animated: true)
    }
    
    private func saveData(userInput : String){
        let score = Score(name: userInput,
                          score: numOfMoves,
                          date: Date.getCurrentDate(),
                          lat: UserDefaults.standard.double(forKey: Constants.latitude),
                          lon: UserDefaults.standard.double(forKey: Constants.longitude))
        
        //load Data
        let dataManagment = DataManagment()
        let topTen = dataManagment.getSavedScoreArray()
        topTen.scoreArray.append(score)
        
        
        //save Data
        dataManagment.saveScoreArray(topTenScores: topTen)
        
        //move to score page
        
        
        
        let vc = storyboard?.instantiateViewController(identifier: "ScoreController") as! ScoreController
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
        
    }
 }
 
 //Mark: collectionView  delegate
 extension GameController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //first card filp
        if (previousIndex == -1) {
            previousIndex = indexPath.row
            choiceNumber += 1
            firstChoice = game_collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell
            firstChoice.setImage(with: UIImage(named: dataSource[indexPath.row])!)
        }
        //second card flip. user can't chose the same card twice
        else if(previousIndex != indexPath.row && choiceNumber == 1){
            
            secondChoice = game_collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell
            
            //only if the card wasn't revealed previously
            if(secondChoice.imageView.image == UIImage(named: "card")){
                choiceNumber += 1
                secondChoice.setImage(with: UIImage(named: dataSource[indexPath.row])!)
                _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(check), userInfo: nil, repeats: false)
            }
        }
    }
 }
 
 
 //MARK: collectionView settings
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
        let numOfRows : Int = UserDefaults.standard.integer(forKey: Constants.rows)
        return CGSize(width: game_collectionView.frame.width/4, height: game_collectionView.frame.height/CGFloat(numOfRows))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
 }
