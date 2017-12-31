//
//  SignUpViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/09.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var backSignIn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpApiButton: UIButton!
    @IBOutlet weak var watch_word: UITextField!
    
    var toolBar:UIToolbar!
    var loadDataObserve: NSObjectProtocol?
    
//    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        // Do any additional setup after loading the view.
        if (self.emailTextField.text?.isEmpty)! && (self.passwordTextField.text?.isEmpty)! && (self.firstNameTextField.text?.isEmpty)! && (self.lastNameTextField.text?.isEmpty)!  && (self.watch_word.text?.isEmpty)! {
            self.signUpApiButton.isEnabled = false
            self.signUpApiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        }
//        datePicker.datePickerMode = .date
//        //datepicker上のtoolbarのdoneボタン
//        toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let toolBarBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//        toolBar.setItems([toolBarBtn], animated: false)
//        self.birthdayTextField.inputAccessoryView = toolBar
//        self.birthdayTextField.inputView = datePicker
        
        
        
    }
    
//    @objc func donePressed() {
//        let df = DateFormatter()
//        df.dateFormat = "yyyy年MM月dd日"
//        self.birthdayTextField.text = "\(df.string(from: datePicker.date))"
//        self.view.endEditing(true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* 以下は UITextFieldDelegate のメソッド */
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("改行")
        // キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        print("Clear")
        return true
    }
    
    // テキストフィールドがフォーカスされた時の処理
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 5 {
            
        }
        print("Start")
        return true
    }
    
    
    // テキストフィールドでの編集が終わろうとするときの処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("End")
        // Do any additional setup after loading the view.
        if (self.emailTextField.text?.isEmpty)! || (self.passwordTextField.text?.isEmpty)! || (self.firstNameTextField.text?.isEmpty)! || (self.lastNameTextField.text?.isEmpty)!{
            self.signUpApiButton.isEnabled = false
            self.signUpApiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        }else {
            self.signUpApiButton.isEnabled = true
            self.signUpApiButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            
        }
        return true
    }
    @IBAction func signUpApi(_ sender: Any) {
        //メールチェック
        if !self.isValidEmail(string: self.emailTextField.text!){
            
            let alert = UIAlertController(title:"メールアドレス不正", message: "メールアドレスが不正です。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
        }else {
            //　パスワードチェック
            if self.passwordTextField.text!.characters.count < 8 {
                let alert = UIAlertController(title:"パスワード", message: "パスワードの文字列を8文字以上で設定してください。", preferredStyle: UIAlertControllerStyle.alert)
                let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction!) in
                    
                })
                alert.addAction(action1)
                
                self.present(alert, animated: true, completion: nil)
            }else {
                SVProgressHUD.show()
                let authApi = AuthApi()
                NotificationCenter.default.addObserver(
                    forName: .authApiLoadComplate,
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
                        
                        
                        if authApi.errFlg {
                            let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                                (action: UIAlertAction!) in
                                
                            })
                            alert.addAction(action1)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }else {
                            
//                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                })
                authApi.signUp(
                    email: self.emailTextField.text!,
                    password: self.passwordTextField.text!,
                    first_name: self.firstNameTextField.text!,
                    last_name: self.lastNameTextField.text!,
                    watch_word: self.watch_word.text!
                )
                
            }
            
        }
        
    }
    
    func isValidEmail(string: String) -> Bool {
        let email = string
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$"
        let range = email.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        
        if !result {
            // メールアドレス形式ではない
            return false
        } else {
            // メールアドレス形式である
            return true
        }
    }
}
