//
//  CoupleAlbumDetailCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/19.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import Cloudinary

class CoupleAlbumDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var image_name: UILabel!
    var album_image: AlbumImages = AlbumImages() {
        didSet {
            let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
            let cloudinary = CLDCloudinary(configuration: config)
            let tranceform = CLDTransformation().setWidth(300).setHeight(400).setCrop(.crop)
            let stringUrl = cloudinary.createUrl().setTransformation(tranceform).generate(album_image.public_id! + ".jpg")
            let url = URL(string: stringUrl!)
            self.image.image = UIImage(data: try! Data(contentsOf: url!))
            image_name.text = album_image.image_name!
        }
    }
}
