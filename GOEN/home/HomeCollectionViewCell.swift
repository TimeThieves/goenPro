//
//  HomeCollectionViewCell.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/14.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    public var serviceImage: UIImageView?
    
    public var serviceName: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        serviceName = UILabel(frame: CGRect(x:0, y:self.frame.height / 2, width:self.frame.width, height:15))
        serviceName?.font = UIFont(name: "HiraKakuProN-W3", size: 17)
        serviceName?.textAlignment = NSTextAlignment.center
        serviceName?.text = "none"
        
        
        serviceImage  = UIImageView(frame: CGRect(x:0, y:0, width:self.frame.width, height:self.frame.height))
        let image = UIImage(named: "setting")
        serviceImage?.image = image
        
        self.addSubview(serviceImage!)
        self.addSubview(serviceName!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var service: Service = Service() {
        didSet {
            serviceName?.text = service.name!
            
            if service.service_cd! == "0001" {
                
                print("home reload3")
                let image = UIImage(named: "setting")
                self.serviceImage?.image = image
                
            }else if service.service_cd! == "0002" {
                let image = UIImage(named: "bride")
                self.serviceImage?.image = image
                
            }else if service.service_cd! == "0003" {
                let image = UIImage(named: "camera")
                self.serviceImage?.image = image
                
            }
            if service.service_cd! == "0101" {
                
                let image = UIImage(named: "couple")
                
                self.serviceImage?.image = image
                
            }
            
        }
    }
    
    
}
