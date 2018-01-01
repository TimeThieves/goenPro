//
//  CoupleEditViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/27.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD


class CoupleEditViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
    var image_url: String = ""
    
    @IBOutlet weak var editCoupleInfoScrollView: UIScrollView!
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    var target:UIView! //タップされた部品
    var moveY:CGFloat = 0 //移動距離
    let notification = NotificationCenter.default
    var loadObserver: NSObjectProtocol?
    var uploadObserver: NSObjectProtocol?
    
    let coupleApi: CoupleApi = CoupleApi()
    
    var couple_id: Int = 0
    let ipc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ipc.delegate = self
        print("testestestet e     :  "+self.coupleApi.public_id)
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
        print("couple info image selected")
        // 選択された画像
        let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        print(selectImage!)
        self.couple_image.image = selectImage!
        self.dismiss(animated: true, completion: nil )
    }
    // MARK: - UIImagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ipc.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func coupleEditUpdate(_ sender: Any) {
        if couple_image.image == work_couple_image &&
        couple_name.text == work_couple_name &&
        couple_address.text == work_couple_address &&
            couple_marred_date.text == work_marred_date {
            let alertView = UIAlertController(title: "未編集",
                                              message: "変更されている項目がありません。",
                                              preferredStyle: .alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            
            alertView.addAction(action1)
            self.present(alertView, animated: true,completion: nil)
            return
        }
        if couple_image.image == nil ||
            (couple_name.text?.isEmpty)! ||
            (couple_marred_date.text?.isEmpty)! {
            let alertView = UIAlertController(title: "未入力",
                                              message: "未入力の項目があります。",
                                              preferredStyle: .alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            
            alertView.addAction(action1)
            self.present(alertView, animated: true,completion: nil)
            return
        }
        
        let resizeImages = resizeImage(image: couple_image.image!, width: 375)
        let image: Data = UIImagePNGRepresentation(resizeImages)!
        
        SVProgressHUD.show()
        if couple_image.image == work_couple_image {
            print("couple edit start1")
            self.loadObserver = NotificationCenter.default.addObserver(
                forName: .coupleApiLoadComplate,
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
                    
                    if self.coupleApi.error_flg {
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
            
            self.coupleApi.updateCouple(
                couple_id: self.couple_id,
                bride_date: self.couple_marred_date.text!,
                couple_house_zip: self.couple_address.text!,
                couple_name: self.couple_name.text!,
                public_id: self.image_url)
            
        }else {
            
            print("couple edit start2")
            self.uploadObserver = NotificationCenter.default.addObserver(
                forName: .upimageComplate,
                object: nil,
                queue: nil,
                using: {
                    (notification) in
                    
                    self.loadObserver = NotificationCenter.default.addObserver(
                        forName: .coupleApiLoadComplate,
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
                            
                            if self.coupleApi.error_flg {
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
                    
                    self.coupleApi.updateCouple(
                        couple_id: self.couple_id,
                        bride_date: self.couple_marred_date.text!,
                        couple_house_zip: self.couple_address.text!,
                        couple_name: self.couple_name.text!,
                        public_id: self.coupleApi.public_id)
                    
            }
            )
            
            coupleApi.uploadImage(image: image)
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.loadObserver != nil {
            NotificationCenter.default.removeObserver(self.loadObserver!)
        }
        if self.uploadObserver != nil {
            NotificationCenter.default.removeObserver(self.uploadObserver!)
            
        }
    }
    
    
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let ratioSize = image.size.height / image.size.width
        UIGraphicsBeginImageContext(CGSize(width: width, height: width * ratioSize))
        image.draw(in: CGRect(x: 0, y: 0,width: width, height: width * ratioSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }

}
