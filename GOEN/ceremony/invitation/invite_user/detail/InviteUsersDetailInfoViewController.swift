//
//  InviteUsersDetailInfoViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/21.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class InviteUsersDetailInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let api: CeremonyApi = CeremonyApi()
    public var user_id: Int = 0
    public var user_name: String = ""
    var loadObserver: NSObjectProtocol?
    
    @IBOutlet weak var inviteUserInfoTableView: UITableView!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.api.ceremony_photo.count == 0 {
            
            return 1
        }else {
            return 2
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 250
            
        }else {
            return 500
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ttttttttttttttttttt")
        switch indexPath.row {
        case 0:
            print(self.api.user_info)
            let cell:InviteUserDetailBasicTableViewCell = inviteUserInfoTableView.dequeueReusableCell(withIdentifier:"inviteUserDetailBasic",for:indexPath as IndexPath) as! InviteUserDetailBasicTableViewCell
            print("==================")
            if self.api.user_info.id != 0 {
                cell.userInfo = self.api.user_info
            }
            
            return cell
        case 1:
            let cell:InviteUserDetailPhotoTableViewCell = inviteUserInfoTableView.dequeueReusableCell(withIdentifier:"inviteUserPhotoList",for:indexPath as IndexPath) as! InviteUserDetailPhotoTableViewCell
            
            
            return cell
            
        default:
            
            let cell:InviteUserDetailBasicTableViewCell = inviteUserInfoTableView.dequeueReusableCell(withIdentifier:"inviteUserDetailBasic",for:indexPath as IndexPath) as! InviteUserDetailBasicTableViewCell
            print("==================")
            
            return cell
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.user_id)
        
        SVProgressHUD.show()
        self.navBarItem.title = self.user_name
        self.inviteUserInfoTableView.tableFooterView = UIView(frame: .zero)
        
        self.inviteUserInfoTableView.isUserInteractionEnabled = false
        
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .ceremonyApiLoadComplate,
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
                self.inviteUserInfoTableView.reloadData()
                self.inviteUserInfoTableView.isUserInteractionEnabled = true
                
                SVProgressHUD.dismiss()
        })
        
        api.getInviteUserDetail(id: self.user_id)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.loadObserver != nil {
            NotificationCenter.default.removeObserver(self.loadObserver!)
            
        }
    }
    
    @IBAction func setUserInvite(_ sender: Any) {
        
        SVProgressHUD.show()
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .ceremonyApiLoadComplate,
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
                    let alert = UIAlertController(title:"データ不正", message: "エラーが発生しました。もう一度招待をして下さい", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }else {
                    
                    let alert = UIAlertController(title:"招待しました。", message: "招待が完了しました。返事を待ちましょう。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                NotificationCenter.default.removeObserver(self.loadObserver!)
        })
        
        api.setInviteUser(user_id: self.api.user_info.id)
    }
    @IBAction func closeModal(_ sender: Any) {
        print("close")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
