//
//  ServiceViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/19.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class ServiceViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    
    public let serviceApi = UserApi()
    public var service1_num: Int = 0
    public var service2_num: Int = 0
    public let reuseIdentifier = "serviceCell"
    
    var loadDataObserver: NSObjectProtocol?
    
    //セルの余白
    let cellMargin:CGFloat = 2.0
    //(行数)
    let daysPerWeek:Int = 3
    
    override func viewWillAppear(_ animated: Bool) {
       
        
        SVProgressHUD.show()
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
                
                print("Service list length : ")
                print(self.serviceApi.serviceList1.count)
                self.service1_num = self.serviceApi.serviceList1.count
                self.service2_num = self.serviceApi.serviceList2.count
                
                self.serviceCollectionView.reloadData()
                
                NotificationCenter.default.removeObserver(self.loadDataObserver!)
                
        })
        serviceApi.getService()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadDataObserver!)
    }
    
    /*
     Sectionの数
     */
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //Cellの総数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("cell all num")
        print("せるの総数 : 00の方")
        print( self.serviceApi.serviceList1.count)
        
        print("せるの総数 : 01の方")
        print(self.serviceApi.serviceList2.count)
        print(section)
        switch(section){
        case 0:
            return self.serviceApi.serviceList1.count
            
        case 1:
            return self.serviceApi.serviceList2.count
            
        default:
            print("error")
            return 0
        }
    }
    
    // セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ServiceCollectionViewCell
        
        //セルの背景色をランダムに設定する。
        cell.backgroundColor = UIColor(red: CGFloat(drand48()),
                                       green: CGFloat(drand48()),
                                       blue: CGFloat(drand48()),
                                       alpha: 1.0)
        
        cell.layer.cornerRadius = 10.0
        cell.regFlgMessage.text = ""
        
        // Configure the cell
        switch(indexPath.section) {
        case 0:
            
            cell.serviceName.text = self.serviceApi.serviceList1[indexPath.row].name!
            
            if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0001" {
                
                let image = UIImage(named: "setting")
                
                cell.serviceImage.image = image
                
            }else if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0002" {
                let image = UIImage(named: "bride")
                
                cell.serviceImage.image = image
            }else if self.serviceApi.serviceList1[indexPath.row].service_cd! == "0003" {
                let image = UIImage(named: "camera")
                
                cell.serviceImage.image = image
            }
            return cell
        case 1:
            
            cell.serviceName.text = self.serviceApi.serviceList2[indexPath.row].name!
            if self.serviceApi.serviceList2[indexPath.row].service_cd! == "0101" {
                
                let image = UIImage(named: "couple")
                
                cell.serviceImage.image = image
                
            }
            if self.serviceApi.serviceList2[indexPath.row].reg_flg! {
                cell.alpha = 1.0
                cell.regFlgMessage.text = "利用する"
            }else{
                cell.alpha = 0.5
                cell.regFlgMessage.text = "利用しない"
            }
            return cell
        default:
            return cell
        }
    }
    
    /*
     Sectionに値を設定する
     */
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerTitle", for: indexPath) as! ServiceCollectionReusableView
        
        headerView.backgroundColor = UIColor.white
        
        switch(indexPath.section) {
        case 0:
            headerView.headerTitle.text = "初期設定サービス"
            return headerView
        case 1:
            headerView.headerTitle.text = "任意設定サービス"
            return headerView
        default :
            return headerView
        }
    }
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.serviceApi.serviceList2[indexPath.row].reg_flg!)
        switch(indexPath.section) {
        case 0:
            //何もしない
            break
        case 1:
            if self.serviceApi.serviceList2[indexPath.row].reg_flg! {
                print("change true to false")
                self.serviceApi.serviceList2[indexPath.row].reg_flg! = false
                let cell = serviceCollectionView.cellForItem(at: indexPath)! as! ServiceCollectionViewCell
                cell.alpha = 0.2
                cell.regFlgMessage.text = "利用しない"
            }else {
                print("change false to true")
                self.serviceApi.serviceList2[indexPath.row].reg_flg! = true
                let cell = serviceCollectionView.cellForItem(at: indexPath)! as! ServiceCollectionViewCell
                cell.alpha = 1.0
                cell.regFlgMessage.text = "利用する"
            }
            break
        default :
            break
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func serviceRegPush(_ sender: Any) {
        SVProgressHUD.show()
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
                
//                self.dismiss(animated: true, completion: nil)
                print("閉じてよ")
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
                
                NotificationCenter.default.removeObserver(self.loadDataObserver!)
                
        })
        serviceApi.setUserService(serviceList: self.serviceApi.serviceList1 + self.serviceApi.serviceList2)
        
    }
    
}
