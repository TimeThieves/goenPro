//
//  CoupleCreateInfoViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/02.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleCreateInfoViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var couple_name: UITextField!
    @IBOutlet weak var bride_date: UITextField!
    @IBOutlet weak var couple_house_zip: UITextField!
    @IBOutlet weak var propose_word: UITextView!
    
    public var receive_user_email: String = ""
    public var receive_user_name: String = ""
    public var receive_user_id: Int = 0
    public var cohabitation_flg: Bool = false
    
    
    var target:UIView! //タップされた部品
    var moveY:CGFloat = 0 //移動距離
    let notification = NotificationCenter.default

    @IBOutlet weak var couple_create_scroll_view: UIScrollView!
    var loadDataObserver: NSObjectProtocol?
    
    var coupleApi: CoupleApi = CoupleApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.couple_name.delegate = self
        self.bride_date.delegate = self
        self.couple_house_zip.delegate = self
        self.propose_word.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func reg_couple_info(_ sender: Any) {
        
        if self.couple_house_zip.text! != "" {
            cohabitation_flg = true
        }
        
        if self.couple_name.text! == "" && self.bride_date.text! == "" && self.couple_house_zip.text! == "" && self.propose_word.text! == "" {
            
            let alert = UIAlertController(title:"入力謝り", message: "入力が完了していません。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        SVProgressHUD.show()
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
                    
                    
                }else {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    self.performSegue(withIdentifier: "createCoupleInfo", sender: nil)
                }
                
                SVProgressHUD.dismiss()
        })
        
        coupleApi.setCoupleInfo(receive_user_id: self.receive_user_id,
                                couple_house_zip: self.couple_house_zip.text!,
                                cohabitation_flg: self.cohabitation_flg,
                                bride_date: self.bride_date.text!,
                                propose_message: self.propose_word.text!,
                                couple_name: self.couple_name.text!)
    }
    
    //キーボードが開くときの呼び出しメソッド
    @objc func keyboardWillBeShown(notification:NSNotification) {
        print("test6666666666666666666")
        //キーボードのフレームを取得する。
        if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            //部品とキーボードがかぶっていかを判定
            let zureY = target.frame.maxY - couple_create_scroll_view.contentOffset.y - keyboardFrame.minY
            
            if (zureY > 0) {
                //スクロールビューをずらす
                couple_create_scroll_view.contentInset.bottom += zureY
                couple_create_scroll_view.contentOffset.y += zureY
                moveY += zureY
            }
        }
    }
    //キーボードが閉じられるときの呼び出しメソッド
    @objc func keyboardWillBeHidden(notification:NSNotification){
        
        //スクロールビューの位置を元に戻す。
        UIView.animate(withDuration: 0.5, animations: {self.couple_create_scroll_view.contentOffset.y -= self.moveY})
        couple_create_scroll_view.contentInset = UIEdgeInsets.zero
        moveY = 0
    }
    
}
