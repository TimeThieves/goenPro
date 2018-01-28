//
//  MyBridalInviListViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/16.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyBridalInviListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let api: CeremonyApi = CeremonyApi()
    var height: CGFloat = 0.0
    var loadObserver: NSObjectProtocol?
    
    @IBOutlet weak var invButton: UIButton!
    @IBOutlet weak var myBridalInvTableView: UITableView!
    @IBOutlet weak var inviteBUtton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool){
        print("test8")
        super.viewWillAppear(true)
        print("my bridal invi")
        myBridalInvTableView.delegate = self
        myBridalInvTableView.allowsSelection = false
        SVProgressHUD.show()
        loadObserver = NotificationCenter.default.addObserver(
            forName: .ceremonyApiLoadComplate,
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
                self.myBridalInvTableView.reloadData()
                SVProgressHUD.dismiss()
        })
        
        api.getMyBridalInvitationUser()
        self.myBridalInvTableView.tableFooterView = UIView(frame: .zero)
        self.myBridalInvTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.api.invitationList.count == 0 {
            
            return 1
        }else {
            
            return self.api.invitationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.api.invitationList.count == 0 {
            
            let cell: NoDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "noDataMyBridal")! as! NoDataTableViewCell
            print("rrr")
            cell.nomessageLabel.sizeToFit()
            cell.nodataMessageHeight.constant = cell.nomessageLabel.frame.height
            self.height = cell.nodataMessageHeight.constant
            return cell
        }else {
            
            let cell: MyBridalInvTableViewCell = tableView.dequeueReusableCell(withIdentifier: "mybridalInvCell")! as! MyBridalInvTableViewCell
            
            cell.invitationInfo = self.api.invitationList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.api.invitationList.count == 0 {
            
            return self.height + 150.0
            
        }else {
            return 120
        }
    }
    
    @IBAction func setMyBridalInv(_ sender: Any) {
    }
    
}
