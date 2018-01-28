//
//  MyBrideSecReceptionHoldingInfoCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/06.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class MyBrideSecReceptionHoldingInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scd_reception_place_name: UILabel!
    @IBOutlet weak var scd_reception_address: UILabel!
    @IBOutlet weak var scd_reception_holding_time: UILabel!
    
    @IBOutlet weak var nameview: UIView!
    @IBOutlet weak var addressview: UIView!
    @IBOutlet weak var timeview: UIView!
    
    var ceremonyInfo: Ceremony = Ceremony() {
        didSet {
            if ceremonyInfo.reception_place_name! == "" {
                scd_reception_place_name.text! = "未設定"
                scd_reception_holding_time.text! = "未設定"
                scd_reception_address.text! = "未設定"
            }else{
                scd_reception_holding_time.text! = ceremonyInfo.scd_reception_holding_time!
                scd_reception_address.text! = ceremonyInfo.scd_reception_place_zip! + " " + ceremonyInfo.scd_reception_place_address!
                scd_reception_place_name.text! = ceremonyInfo.scd_reception_place_name!
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
