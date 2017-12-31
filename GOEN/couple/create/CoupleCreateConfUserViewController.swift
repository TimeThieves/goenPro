//
//  CoupleCreateViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/11.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleCreateConfUserViewController: UIViewController {

    @IBOutlet weak var receive_user_email: UITextField!
    @IBOutlet weak var receive_user_watch_word: UITextField!
    
    @IBOutlet var confView: UIView!
    var coupleApi: CoupleApi = CoupleApi()
    var loadDataObserver: NSObjectProtocol?
    public var receive_user_name: String = ""
    public var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func closeModal(_ sender: Any) {
        print("close")
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func gotoCoupleInfoCreate(_ sender: Any) {
        if self.receive_user_email.text! == "" && self.receive_user_watch_word.text! == "" {
            let alert = UIAlertController(title:"入力謝り", message: "アドレスと合言葉を入力してください。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        SVProgressHUD.show()
        self.confView.isUserInteractionEnabled = false
        loadDataObserver = NotificationCenter.default.addObserver(
            forName: .coupleApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
                print("API Load Complate!")
                
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
                print(self.coupleApi.couple)
                if self.coupleApi.no_partner {
                    let alert = UIAlertController(title:"パートナー情報不正", message: "パートナーのアドレス、もしくは合言葉が誤っています。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }else {
                    
                    self.confView.isUserInteractionEnabled = true
                    
                    self.performSegue(withIdentifier: "createCoupleInfo", sender: nil)
                }
                
                SVProgressHUD.dismiss()
        })
        
        coupleApi.getPartnerInfo(email: self.receive_user_email.text!, watch_word: self.receive_user_watch_word.text!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if loadDataObserver != nil {
            
            NotificationCenter.default.removeObserver(self.loadDataObserver!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createCoupleInfo" {
            print("couple information create")
            let itemView: CoupleCreateInfoViewController = (segue.destination as? CoupleCreateInfoViewController)!
            itemView.receive_user_name = self.coupleApi.couple.receive_user.first_name! + " " + self.coupleApi.couple.receive_user.last_name!
            itemView.receive_user_email = self.coupleApi.couple.receive_user.email!
            itemView.receive_user_id = self.coupleApi.couple.receive_user.id
            
            
        }
    }

}
