//
//  RecentTableViewCell.swift
//  bbm
//
//  Created by ericsong on 15/12/23.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var lasttime: UILabel!
    
    @IBOutlet weak var lastuericon: UIImageView!
    
    @IBOutlet weak var messnum: BadgeView!
    
}
    