//
//  CoupleAlbumCreateViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/15.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleAlbumCreateViewController: UIViewController, UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var albumTitleInput: UITextField!
    var loadObserver: NSObjectProtocol?
    
    let coupleAlbumApi = CoupleAlbumApi()
    var couple_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albumTitleInput.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAlbum(_ sender: Any) {
        if albumTitleInput.text!.isEmpty {
            let alertView = UIAlertController(title: "入力エラー",
                                              message: "アルバム名が未入力です。",
                                              preferredStyle: .alert)
            
            alertView.addAction(
                UIAlertAction(title: "閉じる",
                              style: .default){
                                action in return
                }
            )
            self.present(alertView, animated: true,completion: nil)
            
            return
        }
        SVProgressHUD.show()
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .coupleAlbumApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
                SVProgressHUD.dismiss()
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
                
                if self.coupleAlbumApi.error_flg {
                    let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }else {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                NotificationCenter.default.removeObserver(self.loadObserver!)
        })
        
        coupleAlbumApi.setCoupleAlbum(
            title: albumTitleInput.text!,
            couple_id: self.couple_id
        )
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("close keyboard")
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    //テキストフィールド編集前の呼び出しメソッド
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(textField)
        // キーボードを隠す
        
        textField.resignFirstResponder()
        return true
    }
    
    //テキストビュー編集前の呼び出しメソッド
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("change")
//        target = textView
        return true
    }
    
    //キーボードが開くときの呼び出しメソッド
    @objc func keyboardWillBeShown(notification:NSNotification) {
        
//        //キーボードのフレームを取得する。
//        if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
//
//            //部品とキーボードがかぶっていかを判定
//            let zureY = target.frame.maxY - createScheduleScrollView.contentOffset.y - keyboardFrame.minY
//            print("test6666666666666666666")
//            print(zureY)
//            print("test6666666666666666666")
//            if (zureY > 0) {
//                //スクロールビューをずらす
//                createScheduleScrollView.contentInset.bottom += zureY
//                createScheduleScrollView.contentOffset.y += zureY
//                moveY += zureY
//            }
//        }
    }
    //キーボードが閉じられるときの呼び出しメソッド
    @objc func keyboardWillBeHidden(notification:NSNotification){
        
//        //スクロールビューの位置を元に戻す。
//        UIView.animate(withDuration: 0.5, animations: {self.createScheduleScrollView.contentOffset.y -= self.moveY})
//        createScheduleScrollView.contentInset = UIEdgeInsets.zero
//        moveY = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }
    
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillBeShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }

}
