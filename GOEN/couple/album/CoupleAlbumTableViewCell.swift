//
//  CoupleAlbumTableViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/13.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit

class CoupleAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumCreateDate: UILabel!
    @IBOutlet weak var albumImageNum: UILabel!
    var titleName: String = ""
    var coupleAlbum: CoupleAlbum = CoupleAlbum() {
        didSet{
            albumTitle.text = coupleAlbum.albumTitle
            
            albumCreateDate.text = coupleAlbum.created_at!
            
            self.albumImageNum.text = String(coupleAlbum.imageNum!) + " 枚"
            
            self.titleName = coupleAlbum.albumTitle!
            
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
