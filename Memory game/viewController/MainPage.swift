//
//  MainPage.swift
//  Memory game
//
//  Created by Yarden Barak on 18/05/2021.
//

import UIKit

class MainPage: UIViewController {

    @IBOutlet weak var mainPage_BTN_play: MyCostumButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func btnPlayClick(_ sender: Any) {
        UserDefaults.standard.setValue(16, forKey: Constants.numOfCards)
        let vc = storyboard?.instantiateViewController(identifier: "game_controller") as! GameController
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
       
    }
}
