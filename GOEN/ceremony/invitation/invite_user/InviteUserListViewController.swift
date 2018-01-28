//
//  InviteUserListViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/18.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class InviteUserListViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userListTable: UITableView!
    
    let api = CeremonyApi()
    var loadObserver: NSObjectProtocol?
    
    var userInfo = [UserInfo]()
    
    var selected_user = UserInfo()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        userSearchBar.delegate = self
        userListTable.delegate = self
        
        userSearchBar.placeholder = "知り合い検索"
        
        self.userListTable.tableFooterView = UIView(frame: .zero)
        self.userSearchBar.showsCancelButton = true
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.api.user_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InviteUserListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "inviteUserListCell")! as! InviteUserListTableViewCell
        cell.userInfo = self.api.user_list[indexPath.row]
        return cell
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.userSearchBar.endEditing(true)
        self.userSearchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text!.isEmpty {
            let alert = UIAlertController(title:"検索文字を入力してください。", message: "招待するユーザーの名前を入力してください。", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        print("反応してる？")
        self.userSearchBar.endEditing(true)
        self.userSearchBar.showsCancelButton = true
        
        SVProgressHUD.show()
        
        self.userListTable.isUserInteractionEnabled = false
        
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
                
                self.userListTable.reloadData()
                self.userListTable.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                print(self.api.user_list)
                
                if self.loadObserver != nil {
                    NotificationCenter.default.removeObserver(self.loadObserver!)
                    
                }
        })
        
        api.getSearchInvitaionUser(first_name: searchBar.text!, last_name: searchBar.text!)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.allowsSelection = true
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        selected_user = self.api.user_list[indexPath.row]
        
        performSegue(withIdentifier: "invitationUserDetail", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "invitationUserDetail" {
            print("waaaaaaaai")
            let view: InviteUsersDetailInfoViewController = (segue.destination as? InviteUsersDetailInfoViewController)!
            
            view.user_id = self.selected_user.id
            view.user_name = self.selected_user.first_name! + " " + self.selected_user.last_name!
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.loadObserver != nil {
            NotificationCenter.default.removeObserver(self.loadObserver!)
            
        }
    }
    
    // テキストフィールド入力開始前に呼ばれる
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("反応してる2？")
        return true
    }
    @IBAction func closeModal(_ sender: Any) {
        print("close")
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
