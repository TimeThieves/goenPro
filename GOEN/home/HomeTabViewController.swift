//
//  HomeTabViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/02.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit

class HomeTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let userdefault = UserDefaults.standard
        print("===============current user id===================")
        print(userdefault.integer(forKey: "user_id"))
        print("===============current user id===================")
        
        if (userdefault.integer(forKey: "user_id") == 0){
            print(" No authentication")
            let storyboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let nextView = storyboard.instantiateInitialViewController()
            present(nextView!, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
