//
//  CeremonyListTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/02.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class CeremonyListTableViewCell: UITableViewCell {

    @IBOutlet weak var ceremony_name: UILabel!
    @IBOutlet weak var ceremony_lead_users_name: UILabel!
    @IBOutlet weak var message_count: UILabel!
    @IBOutlet weak var photo_count: UILabel!
    @IBOutlet weak var ceremony_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func send_message(_ sender: Any) {
    }
    @IBAction func celebrate(_ sender: Any) {
    }
    
}
