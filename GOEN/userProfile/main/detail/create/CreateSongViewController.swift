//
//  CreateSongViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/02/15.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateSongViewController: UIViewController,UITextViewDelegate {
    var navItem = UINavigationItem()
    let navBar = UINavigationBar()
    
    let name = UITextView()
    var api: UserApi = UserApi()
    var loadObserver: NSObjectProtocol?
    public var list = [Hoby]()
    var loadDataObserver: NSObjectProtocol?
    
    let NAME_TEXT: String = "好きな曲を入力してください。"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notification = NotificationCenter.default
        
        navBar.frame = CGRect(x:0 , y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 100)
        navBar.backgroundColor = .white
        
        navItem = UINavigationItem(title: "好きな曲の追加")
        navItem.leftBarButtonItem = UIBarButtonItem(title: "閉じる",style: .plain, target: self, action: #selector(self.close))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "追加",style: .plain, target: self, action: #selector(self.add))
        //ナビゲーションバーにナビゲーションアイテムを格納する。
        navBar.pushItem(navItem, animated:true)
        self.view.addSubview(navBar)
        
        name.frame = CGRect(x: 0, y: 0 , width: 200, height: 50)
        name.text! = NAME_TEXT
        name.textColor = UIColor.lightGray
        name.font = UIFont.systemFont(ofSize: 20)
        
        self.view.addSubview(navBar)
        self.view.addSubview(name)
        
        name.delegate = self
        name.isScrollEnabled = false
        name.translatesAutoresizingMaskIntoConstraints = false
        [
            name.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            name.heightAnchor.constraint(equalToConstant: 50)
            ].forEach{ $0.isActive = true }
        
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func close() {
        
        print("close")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func add() {
        
        print("add")
        
        SVProgressHUD.show()
        loadDataObserver = NotificationCenter.default.addObserver(
            forName: .userApiLoadComplate,
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
                if self.api.errFlg {
                    let alert = UIAlertController(title:"エラー", message: "エラーが発生しました。再度追加ボタンを押してください。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    let alert = UIAlertController(title:"追加完了", message: "あなたの趣味を追加しました。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                SVProgressHUD.dismiss()
        })
        
        self.api.setUserSong(name: name.text!)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
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
        if name.text == NAME_TEXT {
            name.text = ""
            name.textColor = UIColor.black
        }else {
            if name.text == "" {
                if name.text == NAME_TEXT || name.text == "" {
                    print("wai")
                    navItem.rightBarButtonItem?.isEnabled = false
                    
                }else {
                    print("wai2")
                    navItem.rightBarButtonItem?.isEnabled = true
                }
            }
        }
        return true
    }

}
