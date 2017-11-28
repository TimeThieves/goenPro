//
//  CoupleScheduleCreateViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/01.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleScheduleCreateViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var scheduleTime: UITextField!
    @IBOutlet weak var eventTag: UITextField!
    @IBOutlet weak var scheduleDate: UITextField!
    @IBOutlet weak var eventScheduleDetail: UITextView!
    @IBOutlet weak var eventPlace: UITextField!
    @IBOutlet weak var createScheduleScrollView: UIScrollView!
    
    let FitAssessment:[(myKey: String, myValue: String)] = [("記念日", "1"), ("デート", "2"), ("打ち合わせ","3"),("結婚式","4")]
    let coupleScheduleApi = CoupleScheduleApi()
    // ①テキストフィールドにDatePickerを表示する
    let datePicker = UIDatePicker()
    let datePicker2 = UIDatePicker()
    let eventTagSec = UIPickerView()
    
    let dateFormat = DateFormatter()
    var target:UIView! //タップされた部品
    var moveY:CGFloat = 0 //移動距離
    let notification = NotificationCenter.default
    var eventTagValue:String = ""
    var create_update_flg:Int = 0
    var sorceEventName: String = ""
    var sorceScheduleDate: String = ""
    var sorceScheduleTime: String = ""
    var sorceEventTag: String = ""
    var sorceEventPlace: String = ""
    var sorceEventDetail: String = ""
    var sorceId: Int = 0
    
    override func viewDidLoad() {
        print(create_update_flg)
        eventName.delegate = self
        eventScheduleDetail.delegate = self
        scheduleTime.delegate = self
        eventTag.delegate = self
        scheduleDate.delegate = self
        eventPlace.delegate = self
        super.viewDidLoad()
        datePicker.datePickerMode = .time
        datePicker2.datePickerMode = .date
        eventTagSec.delegate = self
        eventTagSec.dataSource = self as? UIPickerViewDataSource
        eventTagSec.showsSelectionIndicator = true
        
        eventName.text = sorceEventName
        scheduleDate.text = sorceScheduleDate
        scheduleTime.text = sorceScheduleTime
        eventTag.text = sorceEventTag
        eventPlace.text = sorceEventPlace
        eventScheduleDetail.text = sorceEventDetail
        
        
        datePicker.minuteInterval = 30
        
        scheduleTime.inputView = datePicker
        scheduleDate.inputView = datePicker2
        eventTag.inputView = eventTagSec
        // ②日本の日付表示形式にする
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker2.locale = Locale(identifier: "ja_JP")
        
        //ボタンの設定
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
        
        scheduleDate.inputAccessoryView = pickerToolBar
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar2 = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0))
        pickerToolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar2.barStyle = .blackTranslucent
        pickerToolBar2.tintColor = UIColor.white
        pickerToolBar2.backgroundColor = UIColor.black
        
        let toolBarBtnTime      = UIBarButtonItem(title: "時間の設定", style: .done, target: self, action: #selector(toolBarBtnTimePush))
       
        //ツールバーにボタンを表示
        pickerToolBar2.items = [spaceBarBtn,toolBarBtnTime]
        scheduleTime.inputAccessoryView = pickerToolBar2
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar3 = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0))
        pickerToolBar3.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar3.barStyle = .blackTranslucent
        pickerToolBar3.tintColor = UIColor.white
        pickerToolBar3.backgroundColor = UIColor.black
        
        let toolBarBtnEventTag      = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(toolBarBtnEventTagPush))
        
        //ツールバーにボタンを表示
        pickerToolBar3.items = [spaceBarBtn,toolBarBtnEventTag]
        eventTag.inputAccessoryView = pickerToolBar3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeModal(_ sender: Any) {
        print("close")
        self.dismiss(animated: true, completion: nil)
    }
    
    //datepickerが選択されたらtextfieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        print("text field date pichekr")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd";
        scheduleTime.text = dateFormatter.string(from: sender.date)
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        print(datePicker2.date)
        dateFormat.dateFormat = "yyyy/MM/dd"
        scheduleDate.text = dateFormat.string(from: datePicker2.date)
        
        self.view.endEditing(true)
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnTimePush(sender: UIBarButtonItem){
        print(datePicker.date)
        dateFormat.dateFormat = "HH:mm"
        scheduleTime.text = dateFormat.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnEventTagPush(sender: UIBarButtonItem){
        
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return FitAssessment.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return FitAssessment[row].myKey
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.eventTag.text = FitAssessment[row].myKey
        self.eventTagValue = FitAssessment[row].myValue
    }
    
    //作成ボタン押した時の処理
    @IBAction func createSchedule(_ sender: Any) {
        print(sorceId)
        coupleScheduleApi.id = sorceId
        if eventName.text!.isEmpty || scheduleTime.text!.isEmpty||eventTag.text!.isEmpty || scheduleDate.text!.isEmpty || eventScheduleDetail.text!.isEmpty || eventPlace.text!.isEmpty  {
            print("text is nil...")
            let alert = UIAlertController(title:"入力値の誤り", message: "再入力お願いします。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            return
        }else {
            let test = FitAssessment.index(where: {$0.myKey == "結婚式"})
            print(test!)
            
            SVProgressHUD.show()
            NotificationCenter.default.addObserver(
                forName: .coupleScheduleApiLoadComplate,
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
                    
                    
                    if self.coupleScheduleApi.error_flg {
                        let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                        let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                            (action: UIAlertAction!) in
                            
                        })
                        alert.addAction(action1)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }else {
                            
                        self.dismiss(animated: true, completion: nil)
                    }
                    NotificationCenter.default.removeObserver(self)
            })
            
            coupleScheduleApi.setCoupleSchedule(
                event_name: eventName.text!,
                schedule_date: scheduleDate.text!,
                schedule_time: scheduleTime.text!,
                schedule_detail: eventScheduleDetail.text!,
                event_place: eventPlace.text!,
                event_tag: eventTagValue,
                create_update_flg: self.create_update_flg)
        }
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
        target = textField
        return true
    }
    
    //テキストビュー編集前の呼び出しメソッド
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("change")
        target = textView
        return true
    }
    
    //キーボードが開くときの呼び出しメソッド
    @objc func keyboardWillBeShown(notification:NSNotification) {
        print("test6666666666666666666")
        //キーボードのフレームを取得する。
        if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            //部品とキーボードがかぶっていかを判定
            let zureY = target.frame.maxY - createScheduleScrollView.contentOffset.y - keyboardFrame.minY
            print("test6666666666666666666")
            print(zureY)
            print("test6666666666666666666")
            if (zureY > 0) {
                //スクロールビューをずらす
                createScheduleScrollView.contentInset.bottom += zureY
                createScheduleScrollView.contentOffset.y += zureY
                moveY += zureY
            }
        }
    }
    //キーボードが閉じられるときの呼び出しメソッド
    @objc func keyboardWillBeHidden(notification:NSNotification){
        
        //スクロールビューの位置を元に戻す。
        UIView.animate(withDuration: 0.5, animations: {self.createScheduleScrollView.contentOffset.y -= self.moveY})
        createScheduleScrollView.contentInset = UIEdgeInsets.zero
        moveY = 0
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
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
}
