//
//  XiaoquTableViewCell.swift
//  bbm
//
//  Created by ericsong on 16/1/4.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class XiaoquTableViewCell: UITableViewCell {

   
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var address: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
