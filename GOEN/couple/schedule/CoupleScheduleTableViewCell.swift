//
//  CoupleScheduleTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/31.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit

class CoupleScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var coupleName: UILabel!
    @IBOutlet weak var scheduleTime: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventTag: UILabel!
    
    var coupleSchedule: CoupleSchedule = CoupleSchedule() {
        didSet {
            coupleName.text = coupleSchedule.eventName
            scheduleTime.text = coupleSchedule.scheduleTime
            eventPlace.text = coupleSchedule.eventPlace
            
            if coupleSchedule.eventTag == "1" {
                eventTag.text = "記念日"
            }else if coupleSchedule.eventTag == "2" {
                eventTag.text = "デート"
            }else if coupleSchedule.eventTag == "3" {
                eventTag.text = "打ち合わせ"
            }else if coupleSchedule.eventTag == "4" {
                eventTag.text = "結婚式"
            }
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
