//
//  UserProfileEditViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/10.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserProfileEdit1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var work_id: Int = 0
    public var work_birth_day_date: String? = ""
    public var work_birth_day_year: String? = ""
    public var work_blood_type: String? = ""
    public var work_birth_place: String? = ""
    public var work_university_name: String? = ""
    public var work_university_subject: String? = ""
    public var work_propose_place: String? = ""
    public var work_propose_word: String? = ""
    public var work_user_name: String? = ""
    
    @IBOutlet weak var birth_day: UITextField!
    @IBOutlet weak var blood_type: UITextField!
    
    var api: ProfileApi = ProfileApi()
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    // 選択肢
    let dataList = ["A", "B", "O", "AB"]
    var loadObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        print("edit page")
        
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        
        birth_day.text = work_birth_day_year! + work_birth_day_date!
        blood_type.text = work_blood_type!
        
        birth_day.inputView = datePicker
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
        let toolBarBtn      = UIBarButtonItem(title: "日付の設定", style: .done, target: self, action: #selector(toolBarBtnPush))
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        
        birth_day.inputAccessoryView = pickerToolBar
        // ピッカーの作成
        let picker = UIPickerView()
        picker.center = self.view.center
        
        blood_type.inputView = picker
        // キーボードに表示するツールバーの表示
        let pickerToolBar2 = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0))
        pickerToolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar2.barStyle = .blackTranslucent
        pickerToolBar2.tintColor = UIColor.white
        pickerToolBar2.backgroundColor = UIColor.black
        blood_type.inputAccessoryView = pickerToolBar2
        //完了ボタンを設定
        let toolBarBtn2      = UIBarButtonItem(title: "日付の設定", style: .done, target: self, action: #selector(toolBarBtnPush2))
        //ツールバーにボタンを表示
        pickerToolBar2.items = [spaceBarBtn,toolBarBtn2]
        
        // プロトコルの設定
        picker.delegate = self
        picker.dataSource = self
        
        
    }
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        print(datePicker.date)
        dateFormat.dateFormat = "yyyy/MM/dd"
        birth_day.text = dateFormat.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush2(sender: UIBarButtonItem){
        
        self.view.endEditing(true)
    }
    
    
    // UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 表示する列数
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        return dataList.count
    }
    
    // UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 選択時の処理
        print(dataList[row])
        blood_type.text = dataList[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func user_profile_edit_regist(_ sender: Any) {
        
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
        
        self.api.updateProfile1(id:self.work_id,birth_day: self.birth_day.text!, blood_type: self.blood_type.text!)
        
    }
    
}
