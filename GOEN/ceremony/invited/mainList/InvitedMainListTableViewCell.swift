//
//  InvitedMainListTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/25.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD
import Cloudinary

class InvitedMainListTableViewCell: UITableViewCell {

    @IBOutlet weak var ceremony_name: UILabel!
    @IBOutlet weak var send_user_name: UILabel!
    @IBOutlet weak var receive_user_name: UILabel!
    @IBOutlet weak var joinCeremonyButton: UIButton!
    @IBOutlet weak var joinAppButton: UIButton!
    @IBOutlet weak var couple_image: UIImageView!
    
    var delegate: UIViewController? //必要
    var alert:UIAlertController!
    
    
    let api = CeremonyApi()
    
    var invitationInfo: Invite = Invite() {
        didSet {
            self.delegate = UIViewController() //必要
            ceremony_name.text! = invitationInfo.couple_info.ceremony_info.celemony_name!
            
            let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
            
            send_user_name.text! = invitationInfo.couple_info.send_user.first_name! + " " + invitationInfo.couple_info.send_user.last_name!
            receive_user_name.text! = invitationInfo.couple_info.receive_user.first_name! + " " + invitationInfo.couple_info.send_user.last_name!
            
            let cloudinary = CLDCloudinary(configuration: config)
            
            let stringUrl = cloudinary.createUrl()
                .setTransformation(CLDTransformation()
                    .setWidth(100).setHeight(100).setGravity("face")
                    .setCrop("thumb").setBackground("lightblue")).generate(invitationInfo.couple_info.couple_image! + ".jpg")
            
            let url = URL(string: stringUrl!)
            couple_image.sd_setImage(with: url as URL?)
            
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
