//
//  BirthdayTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/04.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit

class BirthdayTableViewCell: UITableViewCell {

    @IBOutlet weak var birth_day: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
