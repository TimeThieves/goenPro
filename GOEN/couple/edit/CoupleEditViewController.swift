//
//  CoupleEditViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/27.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit

class CoupleEditViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    

    @IBOutlet weak var couple_image: UIImageView!
    @IBOutlet weak var couple_name: UITextField!
    @IBOutlet weak var couple_address: UITextField!
    @IBOutlet weak var couple_marred_date: UITextField!
    var work_couple_image = UIImage()
    var work_couple_name: String = ""
    var work_couple_address: String = ""
    var work_marred_date: String = ""
    
    @IBOutlet weak var editCoupleInfoScrollView: UIScrollView!
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    var target:UIView! //タップされた部品
    var moveY:CGFloat = 0 //移動距離
    let notification = NotificationCenter.default
    
    var couple_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.couple_name.delegate = self
        self.couple_name.delegate = self
        self.couple_address.delegate = self
        self.couple_marred_date.delegate = self
        datePicker.datePickerMode = .date
        
        couple_image.image = work_couple_image
        couple_name.text = work_couple_name
        couple_address.text = work_couple_address
        couple_marred_date.text = work_marred_date
        
        couple_marred_date.inputView = datePicker
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
        
        couple_marred_date.inputAccessoryView = pickerToolBar
        
        let nofitiShow = Notification.Name.UIKeyboardWillShow
//        let nofitiHide = Notification.Name.UIKeyboardWillHide
        
        // Notification の追加
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeShown(notification:)),
            name: nofitiShow,
            object: nil
        )
    }
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func toolBarBtnPush(sender: UIBarButtonItem){
        print(datePicker.date)
        dateFormat.dateFormat = "yyyy/MM/dd"
        couple_marred_date.text = dateFormat.string(from: datePicker.date)
        
        self.view.endEditing(true)
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
            let zureY = target.frame.maxY - editCoupleInfoScrollView.contentOffset.y - keyboardFrame.minY
            print("test6666666666666666666")
            print(zureY)
            print("test6666666666666666666")
            if (zureY > 0) {
                //スクロールビューをずらす
                editCoupleInfoScrollView.contentInset.bottom += zureY
                editCoupleInfoScrollView.contentOffset.y += zureY
                moveY += zureY
            }
        }
    }
    //キーボードが閉じられるときの呼び出しメソッド
    @objc func keyboardWillBeHidden(notification:NSNotification){
        
        //スクロールビューの位置を元に戻す。
        UIView.animate(withDuration: 0.5, animations: {self.editCoupleInfoScrollView.contentOffset.y -= self.moveY})
        editCoupleInfoScrollView.contentInset = UIEdgeInsets.zero
        moveY = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func coupleImagePushButton(_ sender: Any) {
    }
    
    @IBAction func coupleEditUpdate(_ sender: Any) {
    }

}
