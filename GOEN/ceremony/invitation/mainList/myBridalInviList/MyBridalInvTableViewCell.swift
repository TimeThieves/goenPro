//
//  MyBridalInvTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/17.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import Cloudinary

class MyBridalInvTableViewCell: UITableViewCell {
    
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var ceremony_answer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var invitationInfo: Invite = Invite() {
        didSet {
            
            user_name.text! = invitationInfo.user_info.first_name! + " " + invitationInfo.user_info.last_name!
            let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
            let cloudinary = CLDCloudinary(configuration: config)
            
            let stringUrl = cloudinary.createUrl()
                .setTransformation(CLDTransformation()
                    .setWidth(100).setHeight(100).setGravity("face")
                    .setCrop("thumb").setBackground("lightblue")).generate(invitationInfo.user_info.image! + ".jpg")
            
            let url = URL(string: stringUrl!)
            
            if invitationInfo.reg_flg == 0 {
                ceremony_answer.text! = "未返答"
            }else if invitationInfo.reg_flg == 1 {
                ceremony_answer.text! = "挙式に出席"
            }else if invitationInfo.reg_flg == 2 {
                ceremony_answer.text! = "アプリからの参加"
            }
            
            user_image.sd_setImage(with: url as URL?)
            
        }
    }

}
