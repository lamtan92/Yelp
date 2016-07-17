//
//  SelectTableViewCell.swift
//  Yelp
//
//  Created by Lam Tran on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SelectTableViewCellDelegate {
    optional func selectCell(selectCell: SelectTableViewCell, didSelect currentImg: UIImage)
}

class SelectTableViewCell: UITableViewCell {

    @IBOutlet weak var selectLabel: UILabel!
    
    @IBOutlet weak var stateButton: UIButton!
    
    weak var delegate: SelectTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        delegate?.selectCell!(self, didSelect: stateButton.backgroundImageForState(.Normal)!)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onChangeState(sender: UIButton) {
        delegate?.selectCell!(self, didSelect: stateButton.backgroundImageForState(.Normal)!)
    }

}
