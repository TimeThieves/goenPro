//
//  InvitedMainListViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/25.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class InvitedMainListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let api: CeremonyApi = CeremonyApi()
    var loadObserver: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        tableView.delegate = self
        tableView.allowsSelection = false
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
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
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
        })
        
        api.getInvitedUser()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Invited user list")
        if self.api.invitationList.count == 0 {
            print("Invited user list zero")
            return 1
        }else {
            
            return self.api.invitationList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.api.invitationList.count == 0 {
            
            let cell: NoDataInvitedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "noDataInvited")! as! NoDataInvitedTableViewCell
            print("rrr")
            cell.no_message.sizeToFit()
            return cell
        }else {
            
            let cell: InvitedMainListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "invitedListViewCell")! as! InvitedMainListTableViewCell
            
            cell.invitationInfo = self.api.invitationList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.api.invitationList.count == 0 {
            return 150
            
        }else {
            return 200
        }
    }
    @IBAction func joinCeremony(_ sender: UIButton) {
        let cell =  sender.superview?.superview?.superview as! InvitedMainListTableViewCell
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        self.updateJoinFlg(type: 1, invitation_id: self.api.invitationList[row].id)
    }
    
    @IBAction func joinFromApp(_ sender: UIButton) {
        let cell =  sender.superview?.superview?.superview as! InvitedMainListTableViewCell
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        self.updateJoinFlg(type: 2, invitation_id: self.api.invitationList[row].id)
    }
    
    func updateJoinFlg(type: Int, invitation_id: Int){
        var TITLE: String = ""
        var MESSAGE: String = ""
        var BUTTON: String = ""
        if type == 1 {
            TITLE = "挙式に出席"
            MESSAGE = "挙式に参加しますか？"
            BUTTON = "出席します"
        }else if type == 2 {
            TITLE = "アプリから参加"
            MESSAGE = "挙式には出席できませんが、アプリから参加頂けますか？"
            BUTTON = "アプリから参加します"
        }else if type == 3 {
            TITLE = "アプリから参加"
            MESSAGE = "挙式には出席できませんが、アプリから参加頂けますか？"
            BUTTON = "出席します"
        }
        
        let alert = UIAlertController(title:TITLE, message: MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        let action1 = UIAlertAction(title: BUTTON, style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print(invitation_id)
            
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
                    
                    if self.api.error_flg {
                        let alert = UIAlertController(title:"エラー発生", message: "エラーが発生しました。もう一度やり直して下さい。", preferredStyle: UIAlertControllerStyle.alert)
                        let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                            (action: UIAlertAction!) in
                            
                        })
                        alert.addAction(action1)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    NotificationCenter.default.removeObserver(self.loadObserver!)
            })
            self.api.setJoinCeremony(button_type: type, invitation_id: invitation_id)
        })
        let action2 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
        })
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }

}
