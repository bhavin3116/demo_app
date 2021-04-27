//
//  CarListCell.swift
//  mobiLive_Test
//
//  Created by Bhavin on 2021-04-27.
//

import UIKit

class CarListCell: UITableViewCell {

  @IBOutlet weak var assetImage: UIImageView!
  @IBOutlet weak var assetName: UILabel!
  @IBOutlet weak var assetPrice: UILabel!
  @IBOutlet weak var assetRatings: StarRatingView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
