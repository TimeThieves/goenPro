//
//  NoDataTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/17.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nodataMessageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nomessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
