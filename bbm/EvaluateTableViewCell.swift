//
//  EvaluateTableViewCell.swift
//  bbm
//
//  Created by songgc on 16/3/31.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class EvaluateTableViewCell: UITableViewCell {

    @IBOutlet weak var infouser: UILabel!
    
    @IBOutlet weak var ratingbar: RatingBar!
    
    @IBOutlet weak var eveluate: UILabel!
    
    @IBOutlet weak var addtime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
