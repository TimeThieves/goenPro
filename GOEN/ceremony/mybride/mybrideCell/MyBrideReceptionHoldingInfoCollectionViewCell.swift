//
//  MyBrideReceptionHoldingInfoCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/06.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class MyBrideReceptionHoldingInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recep_holding_time: UILabel!
    @IBOutlet weak var recep_holding_place: UILabel!
    @IBOutlet weak var recep_holding_address: UILabel!
    
    @IBOutlet weak var nameview: UIView!
    @IBOutlet weak var addressview: UIView!
    @IBOutlet weak var timeview: UIView!
    
    var ceremonyInfo: Ceremony = Ceremony() {
        didSet {
            if ceremonyInfo.reception_place_name! == "" {
                recep_holding_address.text! = "未設定"
                recep_holding_place.text! = "未設定"
                recep_holding_time.text! = "未設定"
            }else{
                recep_holding_time.text! = ceremonyInfo.reception_holding_time!
                recep_holding_address.text! = ceremonyInfo.reception_place_zip! + " " + ceremonyInfo.reception_place_address!
                recep_holding_place.text! = ceremonyInfo.reception_place_name!
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
