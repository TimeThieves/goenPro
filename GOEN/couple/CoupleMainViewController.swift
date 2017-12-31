//
//  CoupleMainViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/13.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD
import Cloudinary

class CoupleMainViewController: UIViewController {

    @IBOutlet weak var coupleImage: UIImageView!
    @IBOutlet weak var sendUserImage: UIImageView!
    @IBOutlet weak var receiveUserImage: UIImageView!
    @IBOutlet weak var sendUserName: UILabel!
    @IBOutlet weak var receiveUserName: UILabel!
    @IBOutlet var coupleMainView: UIView!
    
    var couple_id: Int = 0
    let coupleApi = CoupleApi()
    
    var loadObserver: NSObjectProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.coupleMainView.isUserInteractionEnabled = false
        loadObserver = NotificationCenter.default.addObserver(
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
                print(self.coupleApi.couple)
//                print(coupleApi.coupleInfo[0].couple_image!)
                if !self.coupleApi.couple.couple_image!.isEmpty {
                    let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
                    let cloudinary = CLDCloudinary(configuration: config)
                    let tranceform = CLDTransformation().setWidth(300).setHeight(400).setCrop(.crop)
                    let stringUrl = cloudinary.createUrl().setTransformation(tranceform).generate(self.coupleApi.couple.couple_image! + ".jpg")
                    let url = URL(string: stringUrl!)
                    self.coupleImage.image = UIImage(data: try! Data(contentsOf: url!))
                }else {
                    let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
                    let cloudinary = CLDCloudinary(configuration: config)
                    let tranceform = CLDTransformation().setWidth(300).setHeight(400).setCrop(.crop)
                    let stringUrl = cloudinary.createUrl().setTransformation(tranceform).generate("sample.jpg")
                    let url = URL(string: stringUrl!)
                    self.coupleImage.image = UIImage(data: try! Data(contentsOf: url!))
                    
                }
                self.sendUserName.text = self.coupleApi.couple.send_user.name
                self.receiveUserName.text = self.coupleApi.couple.receive_user.name
                self.coupleMainView.isUserInteractionEnabled = true
                self.couple_id = self.coupleApi.couple.id
                
                SVProgressHUD.dismiss()
        })
        
        coupleApi.getCouple()

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeModal(_ sender: Any) {
        print("close")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "albumMain" {
            print("prepare")
            let coupleAlbumView: CoupleAlbumViewController = (segue.destination as? CoupleAlbumViewController)!
            coupleAlbumView.couple_id = self.couple_id
            
        } else if segue.identifier == "editCouple" {
            let coupleEditView: CoupleEditViewController = (segue.destination as? CoupleEditViewController)!
            coupleEditView.couple_id = self.couple_id
            coupleEditView.work_couple_image = self.coupleImage.image!
            if !self.coupleApi.couple.couple_image!.isEmpty {
                coupleEditView.image_url = self.coupleApi.couple.couple_image!
            }else {
                coupleEditView.image_url = "sample"
                
            }
            coupleEditView.work_marred_date = self.coupleApi.couple.bride_date!
            if !(self.coupleApi.couple.couple_name?.isEmpty)! {
                coupleEditView.work_couple_name = self.coupleApi.couple.couple_name!
                
            }
            coupleEditView.work_couple_address = self.coupleApi.couple.couple_house_zip!
            
        }
    }
    

}
