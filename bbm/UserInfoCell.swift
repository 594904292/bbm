//
//  UserInfoCell.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

//
// @brief The cell of showing user infos
// @author huangyibiao
//
class UserInfoCell : UITableViewCell {
    var userNameLabel : UILabel!
    var phoneLabel : UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userNameLabel = UILabel(frame: CGRectMake(30, 0, 100, 44))
        userNameLabel.backgroundColor = UIColor.clearColor()
        userNameLabel.font = UIFont.systemFontOfSize(14)
        self.contentView.addSubview(userNameLabel)
        
        phoneLabel = UILabel(frame: CGRectMake(120, 0, 200, 20))
        phoneLabel.backgroundColor = UIColor.clearColor()
        phoneLabel.font = UIFont.systemFontOfSize(12)
        self.contentView.addSubview(phoneLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(userModel: UserModel?) {
        if let model = userModel {
            userNameLabel.text = model.userName
            phoneLabel.text = model.phone
        }
    }
}