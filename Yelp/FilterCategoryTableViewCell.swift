//
//  FilterCategoryTableViewCell.swift
//  Yelp
//
//  Created by Lam Tran on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterCategoryTableViewCellDelegate {
    optional func filterCategoryTableViewCell(filterCategoryTableViewCell: FilterCategoryTableViewCell, didChangedValue value: Bool)
}

class FilterCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    
    var delegate: FilterCategoryTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func categorySwitchChangeHandel(sender: UISwitch) {
        print("switch changed: \(sender.on)")
        delegate?.filterCategoryTableViewCell?(self, didChangedValue: categorySwitch.on)
    }

}
