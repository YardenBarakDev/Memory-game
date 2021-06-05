//
//  ScoreTableViewCell.swift
//  Memory game
//
//  Created by Yarden Barak on 30/05/2021.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var scoreCell_name: UILabel!
    @IBOutlet weak var scoreCell_score: UILabel!
    @IBOutlet weak var scoreCell_date: UILabel!
    @IBOutlet weak var scoreCell_place: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
