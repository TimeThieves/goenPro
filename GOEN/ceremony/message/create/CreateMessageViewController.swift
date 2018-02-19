//
//  CreateMessageViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/02/03.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD



class CreateMessageViewController: UIViewController, UITextViewDelegate {
    
    let messageView = UITextView()
    var loadObserver: NSObjectProtocol?
    var navItem = UINavigationItem()
    let navBar = UINavigationBar()
    
    public var couple_id: Int = 0
    let api: CoupleApi = CoupleApi()
    
    override func viewDidLoad() {
        print(couple_id)
        super.viewDidLoad()
        
        let notification = NotificationCenter.default
        
        print("waaaaai")
        view.backgroundColor = .white
        
        
        print(navBar.frame.maxY)
        
        messageView.frame = CGRect(x: 0, y: 0 , width: 200, height: 50)
        
        messageView.textColor = UIColor.lightGray
        messageView.text = "メッセージを入力しましょう。"
        messageView.font = UIFont.systemFont(ofSize: 20)
        
        self.view.addSubview(messageView)
        
        navVarInit()
        
        self.view.addSubview(navBar)
        messageView.delegate = self
        messageView.isScrollEnabled = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        [
            messageView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageView.heightAnchor.constraint(equalToConstant: 50)
            ].forEach{ $0.isActive = true }
        
        
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func insertMessage() {
        SVProgressHUD.show()
        loadObserver = NotificationCenter.default.addObserver(
            forName: .coupleApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
                print("ceremony API Load Complate!")
                
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
                
                if self.api.updateFlg {
                    let alertView = UIAlertController(title: "エラー",
                                                      message: "もう一度入力して下さい。",
                                                      preferredStyle: .alert)
                    
                    alertView.addAction(
                        UIAlertAction(title: "閉じる",
                                      style: .default){
                                        action in return
                        }
                    )
                    self.present(alertView, animated: true,completion: nil)
                }else {
                    let alertView = UIAlertController(title: "送信完了",
                                                      message: "メッセージを送信しました。",
                                                      preferredStyle: .alert)
                    
                    alertView.addAction(
                        UIAlertAction(title: "閉じる",
                                      style: .default){
                                        action in
                                        
                                        
                                        print("close")
                                        self.dismiss(animated: true, completion: nil)
                                            
                                        
                                        return
                        }
                    )
                    self.present(alertView, animated: true,completion: nil)
                }
                
                SVProgressHUD.dismiss()
        })
        
        self.api.insertMessage(message: messageView.text!, couple_id: self.couple_id)
        
        
    }
    
    func navVarInit() {
        
        
        navBar.frame = CGRect(x:0 , y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 100)
        navBar.backgroundColor = .white
        
        navItem = UINavigationItem(title: "メッセージ作成")
        navItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる",style: .plain, target: self, action: #selector(self.close))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "送信",style: .plain, target: self, action: #selector(self.insertMessage))
        print(messageView.text)
        if messageView.text == "メッセージを入力しましょう。" || messageView.text == "" {
            print("wai")
            navItem.rightBarButtonItem?.isEnabled = false
            
        }else {
            print("wai2")
           navItem.rightBarButtonItem?.isEnabled = true
        }
        
        //ナビゲーションバーにナビゲーションアイテムを格納する。
        navBar.pushItem(navItem, animated:true)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
//        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
//        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
//        UIView.animate(withDuration: duration!, animations: { () in
//            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
//            self.view.transform = transform
//
//        })
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close() {
        
        print("close")
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let size = CGSize(width: view.frame.width ,height: .infinity)
        let estmatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estmatedSize.height
            }
        }
        if textView.text == "" {
            
            navItem.rightBarButtonItem?.isEnabled = false
        }else {
            navItem.rightBarButtonItem?.isEnabled = true
            
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if messageView.text == "メッセージを入力しましょう。" {
            messageView.text = ""
            messageView.textColor = UIColor.black
        }else {
            if messageView.text == "" {
                navVarInit()
            }
        }
        return true
    }

}
