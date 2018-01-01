//
//  CoupleCreateResViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/31.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleCreateResViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var send_user_name: UILabel!
    @IBOutlet weak var send_user_email: UITextField!
    @IBOutlet weak var send_user_watch_word: UITextField!
    let userdefault = UserDefaults.standard
    var loadDataObserver: NSObjectProtocol?
    var coupleApi: CoupleApi = CoupleApi()
    public var send_user_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        send_user_name.text! = userdefault.string(forKey: "send_user_name")!
        send_user_id = userdefault.integer(forKey: "send_user_id")
        // Do any additional setup after loading the view.
        
        send_user_email.delegate = self
        send_user_watch_word.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("close keyboard")
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func destroyRes(_ sender: Any) {
    }
    @IBAction func confSendUser(_ sender: Any) {
        
        if self.send_user_email.text! == "" && self.send_user_watch_word.text! == "" {
            let alert = UIAlertController(title:"入力謝り", message: "アドレスと合言葉を入力してください。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        SVProgressHUD.show()
//        self.confView.isUserInteractionEnabled = false
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
                if self.coupleApi.no_partner {
                    SVProgressHUD.dismiss()
//                    self.confView.isUserInteractionEnabled = true
                    let alert = UIAlertController(title:"パートナー情報不正", message: "パートナーのアドレス、もしくは合言葉が誤っています。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }else {
                    SVProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "coupleCreateResAnswer", sender: nil)
                    
                }
                
        })
        print("~~~~~~~~~~~~~~~~~~")
        print(self.send_user_id)
        print("~~~~~~~~~~~~~~~~~~")

        coupleApi.getSendUserInfo(email: self.send_user_email.text!, watch_word: self.send_user_watch_word.text!, send_user_id: self.send_user_id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "coupleCreateResAnswer" {
            print("couple information create")
            print(self.coupleApi.couple.propose_message!)
            print(self.coupleApi.couple.send_user.profile.image!)
            let itemView: CoupleCreateResAnswerViewController = (segue.destination as? CoupleCreateResAnswerViewController)!
            
            itemView.work_send_user_name = self.coupleApi.couple.send_user.first_name! + " " + self.coupleApi.couple.send_user.last_name!
            
            itemView.work_propose_message = self.coupleApi.couple.propose_message!
            itemView.work_send_user_image = self.coupleApi.couple.send_user.profile.image!
            itemView.work_couple_id = self.coupleApi.couple.id
            
            
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        if self.loadDataObserver != nil {
            NotificationCenter.default.removeObserver(self.loadDataObserver!)
            
        }
    }
    
}
