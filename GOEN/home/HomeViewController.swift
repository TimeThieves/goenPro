//
//  HomeViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/10.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD
class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    private var myActivityIndicator: UIActivityIndicatorView!
    
    
    public let serviceApi = UserApi()
    var loadDataObserver: NSObjectProtocol?
    
    //セルの余白
    let cellMargin:CGFloat = 2.0
    //１週間に何日あるか(行数)
    let daysPerWeek:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        let userdefault = UserDefaults.standard
        print("===============current user id===================")
        print(userdefault.integer(forKey: "user_id"))
        print("===============current user id===================")
        
        if (userdefault.integer(forKey: "user_id") == 0){
            print(" No authentication")
            let storyboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let nextView = storyboard.instantiateInitialViewController()
            present(nextView!, animated: true, completion: nil)
        }else {
            SVProgressHUD.show()
            self.serviceCollectionView.isUserInteractionEnabled = false
            loadDataObserver = NotificationCenter.default.addObserver(
                forName: .userApiLoadComplate,
                object: nil,
                queue: nil,
                using: {
                    (notification) in
                    
                    SVProgressHUD.dismiss()
                    
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
                    
                    if !self.serviceApi.auth_flg {
                        let storyboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                        let nextView = storyboard.instantiateInitialViewController()
                        self.present(nextView!, animated: true, completion: nil)
                    }
                    print("home reload1")
                    self.serviceCollectionView.reloadData()
                    print("home reload2")
                    
                    NotificationCenter.default.removeObserver(self.loadDataObserver!)
                    
                    self.serviceCollectionView.isUserInteractionEnabled = true
                    
            })
            serviceApi.getUserService()
        }
    }
    
    
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //レイアウト調整 行間余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat{
        return 5
    }
    
    //レイアウト調整　列間余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
        return 5
    }
    
    
    //セルのサイズを設定
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize{
        let numberOfMargin:CGFloat = 8.0
        let width:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height:CGFloat = width * 1.0
        return CGSize(width:width,height:height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(3, 3, 3, 3)
    }

    //選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.serviceApi.serviceList1.count > 0  {
        
            if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0001" {
                // 個人データ設定画面
                self.performSegue(withIdentifier: "userInfoEdit", sender: nil)
                
            }else if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0002" {
                // 挙式情報一覧画面
            }else if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0003" {
                // 写真一覧
            }
            if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0101" {
                let userdefault = UserDefaults.standard
                
                if self.serviceApi.couple_info_exist_flg && self.serviceApi.couple_id != 0 {
                    userdefault.set(self.serviceApi.couple_id, forKey: "couple_id")
                    
                    // カップル
                    self.performSegue(withIdentifier: "showCoupleSegue", sender: nil)
                }else if !self.serviceApi.couple_info_exist_flg && self.serviceApi.couple_id != 0{
                    
                    
                    userdefault.set(self.serviceApi.couple_id, forKey: "couple_id")
                    print("==================================")
                    print(self.serviceApi.receive_user_id)
                    print("==================================")
                    print("==================================")
                    print(userdefault.integer(forKey: "user_id"))
                    print("==================================")
                    if self.serviceApi.receive_user_id == userdefault.integer(forKey: "user_id") {
                        let storyboard: UIStoryboard = UIStoryboard(name: "CoupleCreateRes", bundle: nil)
                        let nextView = storyboard.instantiateInitialViewController()
                        userdefault.set(self.serviceApi.send_user_name, forKey: "send_user_name")
                        userdefault.set(self.serviceApi.send_user_id, forKey: "send_user_id")
                        present(nextView!, animated: true, completion: nil)
                        
                    }else {
                        let storyboard: UIStoryboard = UIStoryboard(name: "CreateCouple", bundle: nil)
                        let nextView = storyboard.instantiateInitialViewController()
                        
                        present(nextView!, animated: true, completion: nil)
                        
                    }
                }else {
                    let storyboard: UIStoryboard = UIStoryboard(name: "CreateCouple", bundle: nil)
                    let nextView = storyboard.instantiateInitialViewController()
                    
                    present(nextView!, animated: true, completion: nil)
                }
            }
            
//        }
    }
    
    //セルの総数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.serviceApi.serviceList1.count
    }
    
    //セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"homeCollectionCell",for:indexPath as IndexPath) as! HomeCollectionViewCell
        //セルの背景色をランダムに設定する。
        cell.backgroundColor = UIColor(red: CGFloat(drand48()),
                                       green: CGFloat(drand48()),
                                       blue: CGFloat(drand48()),
                                       alpha: 1.0)
        
        cell.layer.cornerRadius = 10.0
        
        cell.serviceName.text = self.serviceApi.serviceList1[indexPath.row].name!
        
        if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0001" {
            
            print("home reload3")
            let image = UIImage(named: "setting")
            
            cell.serviceImage.image = image
            
        }else if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0002" {
            let image = UIImage(named: "bride")
            
            cell.serviceImage.image = image
        }else if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0003" {
            let image = UIImage(named: "camera")
            
            cell.serviceImage.image = image
        }
        if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0101" {
            
            let image = UIImage(named: "couple")
            
            cell.serviceImage.image = image
            
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CreateCouple" {
            print("couple information create")
                let view: CoupleCreateConfUserViewController = (segue.destination as? CoupleCreateConfUserViewController)!
//                view.couple_id = self.serviceApi.couple_id
            
        }
    }

}
