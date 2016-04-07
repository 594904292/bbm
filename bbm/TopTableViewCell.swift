//
//  TopTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/3/29.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {

    
    @IBOutlet weak var order: UILabel!
    
    @IBOutlet weak var headface: UIImageView!
    
    
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var score: RatingBar!
   
    //@IBOutlet weak var rate: RatingBar!
    //@IBOutlet weak var score: UILabel!
    @IBOutlet weak var nums: UILabel!
    
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
