//
//  CoupleAlbumViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/30.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleAlbumViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadObserver: NSObjectProtocol?
    
    var coupleAlbumApi: CoupleAlbumApi = CoupleAlbumApi()
    var didSelectItem: CoupleAlbum = CoupleAlbum()
    var couple_id: Int = 0
    var titleNmae: String = ""
    @IBOutlet weak var albumTitle: UITextField!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(coupleAlbumApi.album_list.count)
        return coupleAlbumApi.album_list.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "showAlbumDetail", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        didSelectItem = coupleAlbumApi.album_list[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoupleAlbumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CoupleAlbumCell")! as! CoupleAlbumTableViewCell
        
        cell.coupleAlbum = coupleAlbumApi.album_list[indexPath.row]
        return cell
    }
    

    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.tableView.isUserInteractionEnabled = false
        coupleAlbumApi = CoupleAlbumApi()
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .coupleAlbumApiLoadComplate,
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
                self.tableView.reloadData()
                self.tableView.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
        })
        
        coupleAlbumApi.getCoupleAlbum(couple_id: self.couple_id)
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createAlbum" {
            print("prepare")
            let createAlbumView: CoupleAlbumCreateViewController = (segue.destination as? CoupleAlbumCreateViewController)!
            createAlbumView.couple_id = self.couple_id
            
        }else if segue.identifier == "showAlbumDetail" {
            print("Show Album Dtail")
            let createAlbumDetailView: CoupleAlbumDetailViewController = (segue.destination as? CoupleAlbumDetailViewController)!
            
            createAlbumDetailView.noImageDialog = coupleAlbumApi.noImageFlg
            createAlbumDetailView.coupleAlbum = didSelectItem
        }
    }
    
    

}
