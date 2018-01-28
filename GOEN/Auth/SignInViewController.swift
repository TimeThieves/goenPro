//
//  SignInViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/09.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var gotoSignUp: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var serviceFlg: Bool = false
    
    var loadDataObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.buttonStatus()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /* 以下は UITextFieldDelegate のメソッド */
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("改行")
        // キーボードを隠す
        
        self.buttonStatus()
        textField.resignFirstResponder()
        return true
    }
    // テキストフィールドでの編集が終わろうとするときの処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("End")
        
        self.buttonStatus()
        return true
        
    }
    /// UITextFieldの編集開始
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 変更があるとここに来る
        self.buttonStatus()
        
        return true
    }
    
    func buttonStatus() {
        if (self.emailTextField.text?.isEmpty)! || (self.passwordTextField.text?.isEmpty)!{
            self.signInButton.isEnabled = false
            self.signInButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        }else {
            self.signInButton.isEnabled = true
            self.signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            
        }
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        if !isValidEmail(string: self.emailTextField.text!) {
            
            let alert = UIAlertController(title:"メールアドレス不正", message: "メールアドレスが不正です。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        //　パスワードチェック
        if self.passwordTextField.text!.characters.count < 8 {
            let alert = UIAlertController(title:"パスワード", message: "パスワードの文字列を8文字以上で設定してください。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        SVProgressHUD.show()
        let authApi = AuthApi()
        loadDataObserver = NotificationCenter.default.addObserver(
            forName: .authApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
                SVProgressHUD.dismiss()
                print("API Load Complate!")
                print(authApi.errFlg)
                
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
                    
                    NotificationCenter.default.removeObserver(self.loadDataObserver!)
                    
                    let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }else {
                    if(authApi.serviceCdFlg){
                        self.performSegue(withIdentifier: "toServiceReg", sender: nil)
                    }else {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                NotificationCenter.default.removeObserver(self.loadDataObserver!)
        })
        authApi.signIn(
            email: self.emailTextField.text!,
            password: self.passwordTextField.text!
        )
        
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
