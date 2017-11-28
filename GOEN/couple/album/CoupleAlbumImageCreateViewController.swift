//
//  CoupleAlbumImageCreateViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/19.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleAlbumImageCreateViewController: UIViewController,UITextFieldDelegate {
    
    var fromPage: Int = 0
    var image: UIImage = UIImage()
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var imageName: UITextField!
    
    var target:UIView! //タップされた部品
    var moveY:CGFloat = 0 //移動距離
    
    @IBOutlet weak var createScroleView: UIScrollView!
    var loadObserver: NSObjectProtocol?
    var uploadObserver: NSObjectProtocol?
    
    let coupleAlbumApi = CoupleAlbumApi()
    var album_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(image)
        albumImage.image = image
        self.imageName.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("close keyboard")
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    @IBAction func setImageToAlbum(_ sender: Any) {
        
        if imageName.text!.isEmpty {
            let alertView = UIAlertController(title: "入力エラー",
                                              message: "アルバム名が未入力です。",
                                              preferredStyle: .alert)
            
            alertView.addAction(
                UIAlertAction(title: "閉じる",
                              style: .default){
                                action in return
                }
            )
            self.present(alertView, animated: true,completion: nil)
            
            return
        }
        
        // 画像をリサイズしてUIImageViewにセット
        let resizeImages = resizeImage(image: albumImage.image!, width: 375)
        let image: Data = UIImagePNGRepresentation(resizeImages)!
        SVProgressHUD.show()
        
        self.uploadObserver = NotificationCenter.default.addObserver(
            forName: .upimageComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
                
                self.loadObserver = NotificationCenter.default.addObserver(
                    forName: .coupleAlbumApiLoadComplate,
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
                        
                        if self.coupleAlbumApi.error_flg {
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
                
                self.coupleAlbumApi.setCoupleImageToAlbum(
                    image_name: self.imageName.text!,
                    album_id: self.album_id,
                    public_id: self.coupleAlbumApi.public_id
                )
                
            }
        )
        
        coupleAlbumApi.uploadImage(image: image)
    }
    
    func resizeImage(image: UIImage, width: CGFloat) -> UIImage {
        let ratioSize = image.size.height / image.size.width
        UIGraphicsBeginImageContext(CGSize(width: width, height: width * ratioSize))
        image.draw(in: CGRect(x: 0, y: 0,width: width, height: width * ratioSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
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
        
        //キーボードのフレームを取得する。
        if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            //部品とキーボードがかぶっていかを判定
            let zureY = target.frame.maxY - createScroleView.contentOffset.y - keyboardFrame.minY
            print("test6666666666666666666")
            print(zureY)
            print("test6666666666666666666")
            if (zureY > 0) {
                //スクロールビューをずらす
                createScroleView.contentInset.bottom += zureY
                createScroleView.contentOffset.y += zureY
                moveY += zureY
            }
        }
    }
    //キーボードが閉じられるときの呼び出しメソッド
    @objc func keyboardWillBeHidden(notification:NSNotification){
        
        //スクロールビューの位置を元に戻す。
        UIView.animate(withDuration: 0.5, animations: {self.createScroleView.contentOffset.y -= self.moveY})
        createScroleView.contentInset = UIEdgeInsets.zero
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
    
}
