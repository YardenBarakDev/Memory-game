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
        layer.cornerRadius = frame.size.height / 2
        setTitleColor(.white, for: .normal)
    
    }
}
