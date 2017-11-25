//
//  HomeTabBarController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/11.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeTabBarController: UITabBarController {

    @IBOutlet weak var homeTab: UITabBar!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("text2")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ボタン押下時の呼び出しメソッド
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        
        switch item.tag {
        case 1:
            print("==tab 1==")
        case 2:
            print("tab2")
        default:
            return
        }
    }
    

}
