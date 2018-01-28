//
//  MyBrideBasicInfoCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/06.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class MyBrideBasicInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ceremony_name: UILabel!
    @IBOutlet weak var ceremony_message: UITextView!
    
    var ceremonyInfo: Ceremony = Ceremony() {
        didSet {
            ceremony_name.text! = ceremonyInfo.celemony_name!
            ceremony_message.text! = ceremonyInfo.celemony_message!
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
