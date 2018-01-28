//
//  MyBrideHoldingInfoCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/06.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class MyBrideHoldingInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bridal_holding_date: UILabel!
    @IBOutlet weak var bridal_holding_address: UILabel!
    @IBOutlet weak var bridal_holding_place: UILabel!
    
    @IBOutlet weak var nameview: UIView!
    @IBOutlet weak var addressview: UIView!
    @IBOutlet weak var timeview: UIView!
    
    var ceremonyInfo: Ceremony = Ceremony() {
        
        didSet {
            
            nameview.addUnderBorder(height: 1.0, color: UIColor.lightGray)
            addressview.addUnderBorder(height: 1.0, color: UIColor.lightGray)
            timeview.addUnderBorder(height: 1.0, color: UIColor.lightGray)
            
            if ceremonyInfo.bride_place_name == "" {
                bridal_holding_place.text! = "未設定"
                bridal_holding_date.text! = "未設定"
                bridal_holding_address.text! = "未設定"
            }else{
                
                bridal_holding_date.text! = ceremonyInfo.bride_holding_time!
                bridal_holding_address.text! = ceremonyInfo.bride_place_zip! + " " + ceremonyInfo.bride_place_address!
                bridal_holding_place.text! = ceremonyInfo.bride_place_name!
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
