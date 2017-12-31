//
//  UserProfileEdit2ViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/12.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserProfileEdit2ViewController: UIViewController {

    @IBOutlet weak var birth_place: UITextField!
    public var work_id: Int = 0
    public var work_birth_place: String = ""
    
    var api: ProfileApi = ProfileApi()
    var loadObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.birth_place.text = work_birth_place

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func updateProfile2(_ sender: Any) {
        
        print("profile image same")
        SVProgressHUD.show()
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .profileApiLoadComplate,
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
                
                if self.api.error_flg {
                    let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }else {
                    
                    let alert = UIAlertController(title:"更新完了", message: "プロフィールの更新が完了しました。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                NotificationCenter.default.removeObserver(self.loadObserver!)
                
        })
        
        self.api.updateProfile2(birth_place: self.birth_place.text!,id: self.work_id)
        
    
    }
    
}
