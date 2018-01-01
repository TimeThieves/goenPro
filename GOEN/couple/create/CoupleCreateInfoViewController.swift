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
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()

    @IBOutlet weak var couple_create_scroll_view: UIScrollView!
    var loadDataObserver: NSObjectProtocol?
    
    var coupleApi: CoupleApi = CoupleApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.couple_name.delegate = self
        self.bride_date.delegate = self
        self.couple_house_zip.delegate = self
        self.propose_word.delegate = self
        datePicker.datePickerMode = .date
        
        print("===========================")
        print(receive_user_id)
        print("===========================")
        
        bride_date.inputView = datePicker
        datePicker.locale = Locale(identifier: "ja_JP")//ボタンの設定
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action: Selector(""))
        
        //完了ボタンを設定
        let toolBarBtn = UIBarButtonItem(title: "日付の設定", style: .done, target: self, action: #selector(toolBarBtnPush))
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        
        bride_date.inputAccessoryView = pickerToolBar
        
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        print(datePicker.date)
        dateFormat.dateFormat = "yyyy/MM/dd"
        bride_date.text = dateFormat.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func reg_couple_info(_ sender: Any) {
        
        if self.couple_house_zip.text! != "" {
            cohabitation_flg = true
        }else {
            cohabitation_flg = false
        }
        
        if self.couple_name.text! == "" && self.bride_date.text! == "" && self.couple_house_zip.text! == "" && self.propose_word.text! == "" {
            
            let alert = UIAlertController(title:"入力謝り", message: "入力が完了していません。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
            return
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
                    let alert = UIAlertController(title:"送信完了", message: "パートナーに送信しました。返事を持ちましょう。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
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
    
    
    //テキストフィールド編集前の呼び出しメソッド
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("change1")
        print(textField)
        target = textField
        return true
    }
    
    //テキストビュー編集前の呼び出しメソッド
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("change2")
        target = textView
        return true
    }
    //キーボードが閉じられるときの呼び出しメソッド
    @objc func keyboardWillBeHidden(notification:NSNotification){
        
        //スクロールビューの位置を元に戻す。
        UIView.animate(withDuration: 0.5, animations: {self.couple_create_scroll_view.contentOffset.y -= self.moveY})
        couple_create_scroll_view.contentInset = UIEdgeInsets.zero
        moveY = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("test777")
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
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("close keyboard")
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
