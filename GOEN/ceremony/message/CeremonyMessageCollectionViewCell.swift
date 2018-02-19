//
//  CeremonyMessageTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/31.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import Cloudinary

class CeremonyMessageCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
    }
    
    func setUpViews() {
        backgroundColor = .white
        
        user_name.frame = CGRect(x:0, y:0, width: 200, height: 25)
        user_img.frame = CGRect(x:0, y:0, width: 80, height: 80)
        user_msg.frame = CGRect(x:0, y:user_img.frame.height + 10, width: UIScreen.main.bounds.width, height: 80)
        addSubview(user_name)
        addSubview(user_img)
        addSubview(user_msg)
        
        addConst()
    }
    
    func addConst() {
//        user_img.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0).isActive = true
//        user_img.heightAnchor.constraint(equalToConstant: 80.0)
//
        user_name.leadingAnchor.constraint(equalTo: user_img.trailingAnchor, constant: 10.0).isActive = true
//
//        user_msg.topAnchor.constraint(equalTo: user_img.bottomAnchor, constant: 10.0).isActive = true
    }
    
    var user_name: UILabel = {
        let label = UILabel()
        
        label.sizeToFit()
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var user_img: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var user_msg: UITextView = {
        let text = UITextView()
        text.sizeToFit()
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isEditable = false
        text.backgroundColor = .none
        text.font = UIFont.systemFont(ofSize: CGFloat(20))
        return text
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var message: SendCoupleMessage = SendCoupleMessage() {
        didSet {
            let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
            let cloudinary = CLDCloudinary(configuration: config)
            
            let stringUrl = cloudinary.createUrl()
                .setTransformation(CLDTransformation()
                    .setWidth(80).setHeight(80).setGravity("face")
                    .setCrop("thumb").setBackground("lightblue")).generate(message.user.image! + ".jpg")
            
            let url = URL(string: stringUrl!)
            user_img.sd_setImage(with: url as URL?)
            
            user_name.text = message.user.first_name! + " " + message.user.last_name!
            user_msg.text = message.message.message_body!
        }
    }

}
