//
//  InviteUserDetailBasicCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/21.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import Cloudinary
import SVProgressHUD

class InviteUserDetailBasicTableViewCell: UITableViewCell {
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var birth_place: UILabel!
    @IBOutlet weak var educated: UILabel!
    
    @IBOutlet weak var invibutton: UIButton!
    var loadObserver: NSObjectProtocol?
    let api: CeremonyApi = CeremonyApi()
    
    var userInfo: UserInfo = UserInfo() {
        didSet {
            self.invibutton.titleLabel?.text! = "招待する"
            self.invibutton.isEnabled = true
            
            let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
            let cloudinary = CLDCloudinary(configuration: config)
            
            let stringUrl = cloudinary.createUrl()
                .setTransformation(CLDTransformation()
                    .setWidth(100).setHeight(100).setGravity("face")
                    .setCrop("thumb").setBackground("lightblue")).generate(userInfo.image! + ".jpg")
            
            let url = URL(string: stringUrl!)
            
            user_image.image = UIImage(data: try! Data(contentsOf: url!))!
            
            birth_place.text! = userInfo.profile.birth_place! + "出身"
            educated.text! = userInfo.profile.university_name! + " 卒業"
            
        }
    }
    
    @IBAction func invite_user(_ sender: Any) {
    }
}
