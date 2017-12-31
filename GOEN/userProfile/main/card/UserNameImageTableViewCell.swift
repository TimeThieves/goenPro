//
//  UserNameImageTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/04.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit

class UserNameImageTableViewCell: UITableViewCell {
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        user_image.layer.cornerRadius = user_image.frame.size.width * 0.5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
