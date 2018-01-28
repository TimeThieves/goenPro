//
//  CoupleCreateResAnswerViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/01.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import Cloudinary
import SVProgressHUD

class CoupleCreateResAnswerViewController: UIViewController,UITextViewDelegate {
    
    public var work_send_user_name: String = ""
    public var work_send_user_image: String = ""
    public var work_propose_message: String = ""
    public var work_couple_id: Int = 0
    var coupleApi: CoupleApi = CoupleApi()
    var loadDataObserver: NSObjectProtocol?
    
    @IBOutlet weak var send_user_image: UIImageView!
    
    @IBOutlet weak var send_user_name: UILabel!
    
    @IBOutlet weak var propose_message: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        propose_message.delegate = self
        propose_message.isEditable = false
        // Do any additional setup after loading the view.
        
        send_user_name.text = work_send_user_name
        propose_message.text = work_propose_message
        
        
        let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
        let cloudinary = CLDCloudinary(configuration: config)
//        let tranceform = CLDTransformation().setWidth(120).setHeight(120).setGravity("face").setRadius("max").setCrop("thumb")
        
        let stringUrl = cloudinary.createUrl()
            .setTransformation(CLDTransformation()
                .setWidth(80).setHeight(80).setGravity("face")
                .setCrop("thumb").setBackground("lightblue")).generate(work_send_user_image + ".jpg")
        
        let url = URL(string: stringUrl!)
        
        self.send_user_image.image = UIImage(data: try! Data(contentsOf: url!))!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITextViewデリゲートメソッド（textに変更があった際に呼び出される。）
    func textViewDidChange(_ textView: UITextView) {
        let size:CGSize = propose_message.sizeThatFits(propose_message.frame.size)
        propose_message.frame.size.height = size.height
    }
    
    @IBAction func answerRes(_ sender: Any) {
        
        SVProgressHUD.show()
        loadDataObserver = NotificationCenter.default.addObserver(
            forName: .coupleApiLoadComplate,
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
                if !self.coupleApi.updateFlg {
                    
                    print("API Load Complate2!")
                    SVProgressHUD.dismiss()
                    //                    self.confView.isUserInteractionEnabled = true
                    let alert = UIAlertController(title:"エラー", message: "申し訳ありませんが、再度メインメニューから始めてください。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "メインに戻る", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }else {
                    
                    print("API Load Complate3!")
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title:"更新しました", message: "カップルボタンから、情報を見れるようになりました。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "メインに戻る", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }
                
        })
        
        coupleApi.regFlgUpdate(coupleId: self.work_couple_id)
    }
    

}
