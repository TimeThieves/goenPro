//
//  CeremonyMyBrideBasicInfoCreateViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/09.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CeremonyMyBrideBasicInfoCreateViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    
    /*
     update_flg: 1 (insert)
     update_flg: 2 (update)
     モデルに渡して、rails側で判定してもらう
    */
    public var update_flg: Int = 0
    
    @IBOutlet weak var ceremony_name: UITextField!
    @IBOutlet weak var ceremony_couple_message: UITextView!
    @IBOutlet weak var ceremony_holding_date: UITextField!
    
    public var work_ceremony_name: String = ""
    public var work_ceremony_couple_message: String = ""
    public var work_ceremony_holding_date: String = ""
    public var no_message_flg:Bool = true
    var api: CeremonyApi = CeremonyApi()
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    
    var loadObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ceremony_name.text! = work_ceremony_name
        if work_ceremony_couple_message == "" {
            ceremony_couple_message.text! = "友人や大切な人へメッセージをお送りください。"
            ceremony_couple_message.textColor = UIColor.lightGray
            no_message_flg = true
        }else {
            no_message_flg = false
            ceremony_couple_message.text! = work_ceremony_couple_message
        }
        ceremony_holding_date.text! = work_ceremony_holding_date
        ceremony_name.delegate = self
        ceremony_couple_message.delegate = self
        
        // Do any additional setup after loading the view.
        
        datePicker.datePickerMode = .date
        
        ceremony_holding_date.inputView = datePicker
        
        datePicker.locale = Locale(identifier: "ja_JP")//ボタンの設定
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.black
        
        ceremony_name.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        ceremony_holding_date.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,target: self,action: Selector(""))
        
        //完了ボタンを設定
        let toolBarBtn      = UIBarButtonItem(title: "日付の設定", style: .done, target: self, action: #selector(toolBarBtnPush))
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        
        ceremony_holding_date.inputAccessoryView = pickerToolBar
        
        
    }
    
    func textViewShouldBeginEditing(_ textField:UITextView) -> Bool {
        print("edit message")
        if no_message_flg {
            self.ceremony_couple_message.text! = ""
            self.ceremony_couple_message.textColor = UIColor.black
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.ceremony_couple_message.text! == "" {
            no_message_flg = true
            self.ceremony_couple_message.text! = "友人や大切な人へメッセージをお送りください。"
            self.ceremony_couple_message.textColor = UIColor.lightGray
        }else {
            no_message_flg = false
        }
        
        return true
    }
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        print(datePicker.date)
        dateFormat.dateFormat = "yyyy/MM/dd"
        ceremony_holding_date.text = dateFormat.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func updateCeremonyInfo(_ sender: Any) {
        
        if ceremony_holding_date.text! == "" && ceremony_couple_message.text! == "" && ceremony_name.text! == "" {
            let alert = UIAlertController(title:"データ不正", message: "入力されていない項目があります。入力してください。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        SVProgressHUD.show()
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .ceremonyApiLoadComplate,
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
        
        self.api.setMyCeremony(celemony_name: ceremony_name.text!,
                               celemony_holding_date: self.ceremony_holding_date.text!,
                               celemony_message: self.ceremony_couple_message.text!,
                               update_flg: self.update_flg)
    }
    
}
