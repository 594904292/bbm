//
//  DynamicTableViewCell.swift
//  bbm
//
//  Created by ericsong on 15/12/23.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class DynamicTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var info: UILabel!
    
    
    @IBOutlet weak var tag1: UIImageView!
    
    
    @IBOutlet weak var tag2: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
