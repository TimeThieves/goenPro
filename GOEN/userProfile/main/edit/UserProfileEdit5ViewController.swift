//
//  UserProfileEdit5ViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/15.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserProfileEdit5ViewController: UIViewController, UITextFieldDelegate,
UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    var loadObserver: NSObjectProtocol?
    var uploadObserver: NSObjectProtocol?

    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var watch_word: UITextField!
    
    public var work_user_image: UIImage = UIImage()
    public var work_last_name: String = ""
    public var work_first_name: String = ""
    public var work_watch_word: String = ""
    public var work_public_id: String = ""
    
    var api: ProfileApi = ProfileApi()
    
    let ipc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        last_name.delegate = self
        first_name.delegate = self
        watch_word.delegate = self
        
        ipc.delegate = self
        
        user_image.image = work_user_image
        first_name.text! = work_first_name
        last_name.text! = work_last_name
        watch_word.text! = work_watch_word
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("close keyboard")
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    @IBAction func profileImageUpdate(_ sender: Any) {
        let alertView = UIAlertController(title: "写真の追加",
                                          message: "撮影した写真、またはアルバムから追加する。",
                                          preferredStyle: .alert)
        let action1 = UIAlertAction(title: "写真を撮る", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.ipc.sourceType = .camera
            
            self.present(self.ipc, animated: true,completion: nil)
            
        })
        let action2 = UIAlertAction(title: "アルバムから追加", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.ipc.sourceType = .photoLibrary
            
            self.present(self.ipc, animated: true,completion: nil)
            
        })
        let action3 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
        })
        alertView.addAction(action1)
        alertView.addAction(action2)
        alertView.addAction(action3)
        self.present(alertView, animated: true,completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("画像選択")
        // 選択された画像
        let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        print(selectImage!)
        let resizeImages = resizeImage(image: selectImage!, width: 120)
        
        self.user_image.image = resizeImages
        self.user_image.layer.cornerRadius = user_image.frame.size.width * 0.5
        self.dismiss(animated: true, completion: nil )
    }
    
    // MARK: - UIImagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ipc.dismiss(animated: true, completion: nil)
    }
    @IBAction func profileUpdateReg(_ sender: Any) {
        
        let resizeImages = resizeImage(image: user_image.image!, width: 120)
        let image: Data = UIImagePNGRepresentation(resizeImages)!
        
        if first_name.text! == work_first_name && last_name.text! == work_last_name && watch_word.text! == work_watch_word && user_image == work_user_image {
            
            let alert = UIAlertController(title:"未編集", message: "情報が編集されていません", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        SVProgressHUD.show()
        if user_image.image == work_user_image {
            print("profile image same")
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
            
            self.api.updateProfile5(
                first_name: self.first_name.text!,
                last_name: self.last_name.text!,
                watch_word: self.watch_word.text!,
                public_id: self.work_public_id)
            
        }else {
            print("profile image defferent")
            self.uploadObserver = NotificationCenter.default.addObserver(
                forName: .upimageComplate,
                object: nil,
                queue: nil,
                using: {
                    (notification) in
                    
                    self.loadObserver = NotificationCenter.default.addObserver(
                        forName: .profileApiLoadComplate,
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
                            
                            if self.api.error_flg {
                                let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                                let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                                    (action: UIAlertAction!) in
                                    
                                })
                                alert.addAction(action1)
                                
                                self.present(alert, animated: true, completion: nil)
                                
                                
                            }else {
                                
                                self.dismiss(animated: true, completion: nil)
                            }
                            NotificationCenter.default.removeObserver(self.loadObserver!)
                    })
                    
                    self.api.updateProfile5(
                        first_name: self.first_name.text!,
                        last_name: self.last_name.text!,
                        watch_word: self.watch_word.text!,
                        public_id: self.api.public_id)
                    
            }
            )
            
            api.uploadImage(image: image)
        }
    }
    
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let ratioSize = image.size.height / image.size.width
        UIGraphicsBeginImageContext(CGSize(width: width, height: width))
        image.draw(in: CGRect(x: 0, y: 0,width: width, height: width))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
}
