//
//  CeremonyMyBrideMainViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/05.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CeremonyMyBrideMainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var nobride_message: UILabel!
    @IBOutlet weak var nobrideview: UIView!
    @IBOutlet weak var haight: NSLayoutConstraint!
    @IBOutlet weak var bridecollection: UICollectionView!
    
    let api: CoupleApi = CoupleApi()
    
    var ceremony_id: Int = 0
    
    var loadDataObserver: NSObjectProtocol?
    
    let userdefault = UserDefaults.standard
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("ttttttttttttttttttt")
        switch indexPath.row {
        case 0:
            let cell:MyBrideBasicInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"mybridebasic",for:indexPath as IndexPath) as! MyBrideBasicInfoCollectionViewCell
            print("==================")
            print(self.api.couple.ceremony_info)
            cell.ceremonyInfo = self.api.couple.ceremony_info
            
            return cell
        case 1:
            let cell:MyBrideHoldingInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"mybrideHolding",for:indexPath as IndexPath) as! MyBrideHoldingInfoCollectionViewCell
            cell.ceremonyInfo = self.api.couple.ceremony_info
            return cell
        case 2:
            let cell:MyBrideReceptionHoldingInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"MybrideReceptionHolding",for:indexPath as IndexPath) as! MyBrideReceptionHoldingInfoCollectionViewCell
            cell.ceremonyInfo = self.api.couple.ceremony_info
            return cell
        case 3:
            let cell:MyBrideSecReceptionHoldingInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"MybrideSecReceptionHolding",for:indexPath as IndexPath) as! MyBrideSecReceptionHoldingInfoCollectionViewCell
            cell.ceremonyInfo = self.api.couple.ceremony_info
            return cell
            
        default:
            
            let cell:MyBrideBasicInfoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"mybridebasic",for:indexPath as IndexPath) as! MyBrideBasicInfoCollectionViewCell
            return cell
        }
    }
    //セルのサイズ（CGSize）を指定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width, height: 148)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: 280)
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        bridecollection.delegate = self
        
        self.bridecollection.isUserInteractionEnabled = false
        
        loadDataObserver = NotificationCenter.default.addObserver(
            forName: .coupleApiLoadComplate,
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
                print("ceremony_info is nothing?")
                print(self.api.no_ceremony)
                if self.api.no_ceremony {
                    
                    self.bridecollection.isUserInteractionEnabled = true
                    
                    self.bridecollection.alwaysBounceVertical = true
                    self.bridecollection.isHidden = true
                    self.nobrideview.isHidden = false
                    self.nobrideview.layer.borderColor = UIColor.blue.cgColor
                    self.haight.constant = 250
                    
                    self.nobride_message.numberOfLines = 0
                    self.nobride_message.sizeToFit()
                    self.nobrideview.layer.borderWidth = 1.0
                }else {
                    self.nobrideview.isHidden = true
                    self.bridecollection.isHidden = false
                    self.bridecollection.alwaysBounceVertical = true
                    self.bridecollection.isUserInteractionEnabled = true
                    self.bridecollection.showsVerticalScrollIndicator = false
                    self.haight.constant = 554
                }
                
                print("home reload1")
                self.bridecollection.reloadData()
                print("home reload2")
                
                NotificationCenter.default.removeObserver(self.loadDataObserver!)
                
        })
        api.getMyCoupleCeremonyInfo()
        
    }
    
    @IBAction func createCeremony(_ sender: Any) {
        if userdefault.integer(forKey: "couple_id") == 0 || userdefault.integer(forKey: "couple_reg_flg") == 0 {
            let alert = UIAlertController(title:"カップル未作成", message: "まだカップルを作成していないようです。まずはパートナーを見つけましょう！", preferredStyle: UIAlertControllerStyle.alert)
            let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                
            })
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
        }else {
            self.performSegue(withIdentifier: "createMyCeremony", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createMyCeremony" {
            print("prepare")
            
            let view: CeremonyMyBrideBasicInfoCreateViewController = (segue.destination as? CeremonyMyBrideBasicInfoCreateViewController)!
            
            view.update_flg = 1
            
            
        }
    }
    

}
