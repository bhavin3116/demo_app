//
//  FilterCell.swift
//  mobiLive_Test
//
//  Created by Bhavin on 2021-04-28.
//

import UIKit

protocol filterDelegates: AnyObject {
  func openModelFilter(_ selection: String)
  func openMakeFilter(_ selection: String)
  func closeFilter(_ selection: String)
}

class FilterCell: UITableViewCell {
  
  weak var filterDelegate: filterDelegates?
  
  @IBOutlet weak var view: UIView! {
    didSet {
      view.layer.cornerRadius = 10
      view.clipsToBounds = true
    }
  }
  @IBOutlet weak var makeFilter: UITextField!{
    didSet {
      makeFilter.delegate = self
      makeFilter.tag = 1
    }
  }
  
  @IBOutlet weak var modelFilter: UITextField! {
    didSet {
      modelFilter.delegate = self
      modelFilter.tag = 2
    }
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}

extension FilterCell: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField.tag == 1 {
      filterDelegate?.openMakeFilter("")
    }
    if textField.tag == 2 {
      filterDelegate?.openModelFilter("")
    }
    return false
  }
}
