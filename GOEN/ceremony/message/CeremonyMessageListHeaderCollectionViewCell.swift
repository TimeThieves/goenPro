//
//  CeremonyMessageListHeaderCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2018/02/03.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class CeremonyMessageListHeaderCollectionViewCell: UICollectionViewCell {
    let messageMakeButton: UIButton = {
        let button = UIButton()
        button.setTitle("メッセージを送りますか？", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.frame = CGRect(x: 0 , y: 0, width: 100, height: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        print("message button in header")
        backgroundColor = .white
        addSubview(messageMakeButton)
        messageMakeButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageMakeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        messageMakeButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        messageMakeButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
    }
}
