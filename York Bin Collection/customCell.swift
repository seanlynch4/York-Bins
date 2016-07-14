//
//  customCell.swift
//  
//
//  Created by Sean on 14/07/2016.
//
//

import UIKit

class customCell: UITableViewCell {
    
    
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var firstViewLabel: UILabel!
    @IBOutlet var secondView: UIView!
    @IBOutlet var secondViewLabel: UILabel!
    @IBOutlet var secondHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    var showsDetails = false
    {
        didSet
        {
            secondHeightConstraint.priority = showsDetails ? 250 : 999
        }
    }

}
