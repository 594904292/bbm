//
//  fwTableViewCell.swift
//  bbm
//
//  Created by ericsong on 16/2/25.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class fwTableViewCell: UITableViewCell {
    @IBOutlet weak var senduser: UILabel!

    @IBOutlet weak var usertag: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var headface: UIImageView!
    
    
    @IBOutlet weak var zan: UIButton!
    
    @IBOutlet weak var tel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
