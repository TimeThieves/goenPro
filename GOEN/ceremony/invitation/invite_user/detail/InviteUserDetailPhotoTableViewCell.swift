//
//  InviteUserDetailPhotoCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/21.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class InviteUserDetailPhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photo_list: UICollectionView!
    var userInfo: UserInfo = UserInfo() {
        didSet {
            
            
            
        }
    }
    
    func set<T: UICollectionViewDelegate & UICollectionViewDataSource>(collectionDataSourceDelegate: T) {
        photo_list.delegate  = collectionDataSourceDelegate
        photo_list.dataSource = collectionDataSourceDelegate
    }
}
