//
//  FilterCell.swift
//  mobiLive_Test
//
//  Created by Bhavin on 2021-04-28.
//

import UIKit

class FilterCell: UITableViewCell {

  @IBOutlet weak var makeFilter: UITextField!
  @IBOutlet weak var modelFilter: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
