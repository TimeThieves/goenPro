//
//  InviteUserListTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/19.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import Cloudinary

class InviteUserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var user_image: UIImageView!
    
    var userInfo: UserInfo = UserInfo() {
        didSet {
            
            user_name.text! = userInfo.first_name! + " " + userInfo.last_name!
            let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
            let cloudinary = CLDCloudinary(configuration: config)
            
            let stringUrl = cloudinary.createUrl()
                .setTransformation(CLDTransformation()
                    .setWidth(70).setHeight(70).setGravity("face")
                    .setCrop("thumb").setBackground("lightblue")).generate(userInfo.image! + ".jpg")
            
            let url = URL(string: stringUrl!)
            
            user_image.sd_setImage(with: url as URL?)
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
