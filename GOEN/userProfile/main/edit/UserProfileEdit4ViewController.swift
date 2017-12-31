//
//  UserProfileEdit4ViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/12.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserProfileEdit4ViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var propose_place: UITextField!
    @IBOutlet weak var propose_word: UITextView!
    
    public var work_id: Int = 0
    public var work_propose_place: String = ""
    public var work_propose_word: String = ""
    
    var api: ProfileApi = ProfileApi()
    var loadObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        propose_word.delegate = self
        propose_place.delegate = self
        
        propose_place.text! = work_propose_place
        propose_word.text! = work_propose_word

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func updateProfile4(_ sender: Any) {
        
        
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
        
        self.api.updateProfile4(id: self.work_id, propose_place: self.propose_place.text!, propose_word: self.propose_word.text!)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("close keyboard")
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
}
