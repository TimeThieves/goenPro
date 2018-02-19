//
//  UserProfileMainViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/03.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD
class UserProfileMainViewController: UIViewController{
    
    @IBOutlet weak var segumentTab: UISegmentedControl!
    @IBOutlet var basicInfoView: UIView!
    @IBOutlet var ceremonyPhotoView: UIView!
    @IBOutlet weak var basicInfoContner: UIView!
    @IBOutlet var userProfileDetail: UIView!
    //    var detailProfile: UserProfileMainViewController = UserProfileMainViewController()
    
    var api: ProfileApi = ProfileApi()
    var auth_api: AuthApi = AuthApi()
    var loadDataObserver: NSObjectProtocol?
    var loadObserver: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool)  {
        print("profile main")
        basicInfoView.frame = CGRect(x: 0,y: segumentTab.frame.minY + segumentTab.frame.height,width: self.view.frame.width, height: (self.view.frame.height - segumentTab.frame.minY))
        ceremonyPhotoView.frame = CGRect(x: 0,y: segumentTab.frame.minY + segumentTab.frame.height,width: self.view.frame.width, height: (self.view.frame.height - segumentTab.frame.minY))
        userProfileDetail.frame = CGRect(x: 0,y: segumentTab.frame.minY + segumentTab.frame.height,width: self.view.frame.width, height: (self.view.frame.height - segumentTab.frame.minY))
        
        if segumentTab.selectedSegmentIndex == 0 {
            
            self.view.addSubview(basicInfoView)
            
        }else if segumentTab.selectedSegmentIndex == 1 {
            
            self.view.addSubview(ceremonyPhotoView)
            
        }else if segumentTab.selectedSegmentIndex == 2 {
            
            self.view.addSubview(userProfileDetail)
            
        }
        
        
//            self.profileTable.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentTaped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                addFirstView()
            case 1:
                addSecondView()
            case 2:
                addThirdView()
            default:
                addFirstView()
        }
    }
    
    func addFirstView() {
        ceremonyPhotoView.removeFromSuperview()
        userProfileDetail.removeFromSuperview()
        self.view.addSubview(basicInfoView)
    }
    
    func addSecondView() {
        basicInfoView.removeFromSuperview()
        userProfileDetail.removeFromSuperview()
        self.view.addSubview(ceremonyPhotoView)
    }
    
    func addThirdView() {
        basicInfoView.removeFromSuperview()
        ceremonyPhotoView.removeFromSuperview()
        self.view.addSubview(userProfileDetail)
    }
    @IBAction func closeModal(_ sender: Any) {
        print("close")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logout(_ sender: Any) {
        
        
        let alert = UIAlertController(title:"ログアウト", message: "ログアウトします。よろしいですか？", preferredStyle: UIAlertControllerStyle.alert)
        let action1 = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            print("LOGOUT")
            SVProgressHUD.show()
            self.loadObserver = NotificationCenter.default.addObserver(
                forName: .authApiLoadComplate,
                object: nil,
                queue: nil,
                using: {
                    (notification) in
                    SVProgressHUD.dismiss()
                    
                    if notification.userInfo != nil {
                        if let userinfo = notification.userInfo as? [String: String?] {
                            if userinfo["error"] != nil {
                                let alertView = UIAlertController(title: "通信エラー",
                                                                  message: "通信エラーが発生しました。",
                                                                  preferredStyle: .alert)
                                
                                alertView.addAction(
                                    UIAlertAction(title: "閉じる",
                                                  style: .default){
                                                    action in return
                                    }
                                )
                                self.present(alertView, animated: true,completion: nil)
                            }
                        }
                    }
                    
                    
                    print("close")
                    self.dismiss(animated: true, completion: nil)
                    
                    NotificationCenter.default.removeObserver(self.loadObserver!)
                    
            })
            self.auth_api.signout()
            
        })
        alert.addAction(action1)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
