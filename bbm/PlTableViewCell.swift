//
//  PlTableViewCell.swift
//  bbm
//
//  Created by ericsong on 16/1/6.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class PlTableViewCell: UITableViewCell {

    @IBOutlet weak var pltime: UILabel!
    
    @IBOutlet weak var pluser: UILabel!
    @IBOutlet weak var plheadface: UIImageView!
    
    @IBOutlet weak var plcontent: UILabel!
    
    @IBOutlet weak var plgoodbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
