//
//  CremonyListViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/02.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD
import Cloudinary

class CeremonyListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let api: CeremonyApi = CeremonyApi()
    var loadObserver: NSObjectProtocol?
    
    public var work_couple_id: Int = 0
    let userdefault = UserDefaults.standard
    
    @IBOutlet weak var ceremonyTable: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        print("ceremony list page")
        print(userdefault.integer(forKey: "couple_id"))
        print(userdefault.integer(forKey: "user_id"))
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
                
                self.ceremonyTable.reloadData()
                
                if self.api.ceremonyList.count == 0 {
                    self.ceremonyTable.allowsSelection = false
                }else{
                    self.ceremonyTable.allowsSelection = true
                    
                }
                
                SVProgressHUD.dismiss()
        })
        
        api.getCeremonyList()
        
        self.ceremonyTable.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num: Int = 0
        print(self.api.ceremonyList.count)
        if self.api.ceremonyList.count == 0 {
            num = 1
        }else {
            num = self.api.ceremonyList.count
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.api.ceremonyList.count == 0 {
            
            let cell: NoCeremonyListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "noceremonyCell")! as! NoCeremonyListTableViewCell
            cell.nomessage.text! = "まだ挙式情報がありません。"
            return cell
        }else {
            let cell: CeremonyListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ceremoyListCell")! as! CeremonyListTableViewCell
            return cell
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var num: Int = 0
        if self.api.ceremonyList.count == 0 {
            num = 100
        }else{
            num = 300
        }
        return CGFloat(num)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.api.ceremonyList.count == 0 {
            tableView.allowsSelection = false
        }else{
            tableView.allowsSelection = true
            
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "showAlbumDetail", sender: nil)
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sendMessage" {
            print("prepare")
//            let createAlbumView: CoupleAlbumCreateViewController = (segue.destination as? CoupleAlbumCreateViewController)!
//            createAlbumView.couple_id = self.couple_id
            
        }else if segue.identifier == "showAlbumDetail" {
//            print("Show Album Dtail")
//            let createAlbumDetailView: CoupleAlbumDetailViewController = (segue.destination as? CoupleAlbumDetailViewController)!
//
//            createAlbumDetailView.noImageDialog = coupleAlbumApi.noImageFlg
//            createAlbumDetailView.coupleAlbum = didSelectItem
        }
    }

}
