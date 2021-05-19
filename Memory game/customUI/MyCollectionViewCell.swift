import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    static let identifier = String(describing: MyCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setImage(with image : UIImage){
        imageView.image = image
    }
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
}



