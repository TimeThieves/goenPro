//
//  CoupleMainViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/13.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD
class CoupleMainViewController: UIViewController {

    @IBOutlet weak var coupleImage: UIImageView!
    @IBOutlet weak var sendUserImage: UIImageView!
    @IBOutlet weak var receiveUserImage: UIImageView!
    @IBOutlet weak var sendUserName: UILabel!
    @IBOutlet weak var receiveUserName: UILabel!
    @IBOutlet var coupleMainView: UIView!
    
    var couple_id: Int = 0
    
    var loadObserver: NSObjectProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        let coupleApi = CoupleApi()
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
                print(coupleApi.couple)
//                print(coupleApi.coupleInfo[0].couple_image!)
                let url = URL(string: coupleApi.couple.couple_image!)
                self.coupleImage.image = UIImage(data: try! Data(contentsOf: url!))
                self.sendUserName.text = coupleApi.couple.send_user.name
                self.receiveUserName.text = coupleApi.couple.receive_user.name
                self.coupleMainView.isUserInteractionEnabled = true
                self.couple_id = coupleApi.couple.id
                
                SVProgressHUD.dismiss()
                NotificationCenter.default.removeObserver(self)
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
            
        }
    }
    

}
