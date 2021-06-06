import Foundation
import UIKit

class MyCostumButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    func setUpButton(){
        backgroundColor = #colorLiteral(red: 0, green: 0.2911751866, blue: 1, alpha: 1)
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        frame = CGRect(x: 150, y: 150, width: 150, height: 150)
        let attributedString = NSAttributedString(string: NSLocalizedString(self.titleLabel?.text ?? "", comment: ""), attributes:[
            NSAttributedString.Key.underlineColor: UIColor.red,
            NSAttributedString.Key.underlineStyle:1.0
        ])
        setAttributedTitle(attributedString, for: .normal)
    }
}
