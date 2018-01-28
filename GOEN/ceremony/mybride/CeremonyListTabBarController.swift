//
//  CeremonyListTabBarController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/07.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class CeremonyListTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModal(_ sender: Any) {
        print("close")
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
