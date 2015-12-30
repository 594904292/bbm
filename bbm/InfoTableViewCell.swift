//
//  InfoTableViewCell.swift
//  bbm
//
//  Created by ericsong on 15/12/23.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var senduser: UILabel!
    
    @IBOutlet weak var sendtime: UILabel!
    
    @IBOutlet weak var gz: UILabel!
    
    @IBOutlet weak var pl: UILabel!
    
    @IBOutlet weak var Message: UILabel!
    
    @IBOutlet weak var catagory: UILabel!
    
    @IBOutlet weak var sendaddress: UILabel!
    
    @IBOutlet weak var status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
