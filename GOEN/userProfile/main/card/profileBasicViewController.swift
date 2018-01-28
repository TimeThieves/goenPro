//
//  profileBasicViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/04.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD
import Cloudinary

class profileBasicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profileTable: UITableView!
    
    let button: UIButton = UIButton()
    var api: ProfileApi = ProfileApi()
    var loadDataObserver: NSObjectProtocol?
    
    var profile_image: UIImage = UIImage()
    
    override func viewWillAppear(_ animated: Bool) {
        print("profile basic edit")
        self.profileTable.allowsSelection = true
        self.profileTable.layer.cornerRadius = 5.0
        self.profileTable.delegate = self
        
        SVProgressHUD.show()
        //      self.profileTable.isUserInteractionEnabled = false
        self.profileTable.isUserInteractionEnabled = false
        self.loadDataObserver = NotificationCenter.default.addObserver(
            forName: .profileApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
                print("API Load Complate!")
                
                self.profileTable.isUserInteractionEnabled = true
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
                self.profileTable.reloadData()
                
                let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
                let cloudinary = CLDCloudinary(configuration: config)
                let tranceform = CLDTransformation().setWidth(120).setHeight(120).setGravity("face").setRadius("max").setCrop("thumb")
                var image_url: String  = ""
                if self.api.profile.image! == "" {
                    
                    image_url = "sample"
                    
                }else {
                    image_url = self.api.profile.image!
                }
                
                
                let stringUrl = cloudinary.createUrl()
                    .setTransformation(CLDTransformation()
                        .setWidth(120).setHeight(120).setGravity("face")
                        .setCrop("thumb").setBackground("lightblue")).generate(image_url + ".jpg")
                
                let url = URL(string: stringUrl!)
                
                self.profile_image = UIImage(data: try! Data(contentsOf: url!))!
                
                SVProgressHUD.dismiss()
        })
        
        api.getUserProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadDataObserver!)
    }
    
    // Sectioのタイトル
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        
        return "基本情報設定"
    }
    /*
     ⦿ ヘッダーの設定
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myView: UIView = UIView()
        let grayscale = UIColor(white:0.9, alpha:1.0)
        myView.backgroundColor = grayscale
        
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 0, y:15, width: 300, height: 23)
        label.text = "基本情報"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        myView.addSubview(label)
        
        return myView
    }
    @objc func changeColor(sender: Any) {
        // buttonの色を変化させるメソッド
        button.setTitleColor(UIColor.gray, for: .normal)
        
        self.performSegue(withIdentifier: "userProfileEdit", sender: nil)
    }
    @objc func changeColor2(sender: Any) {
        // buttonの色を変化させるメソッド
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "userProfileEdit1" {
            print("couple information create")
            let item: UserProfileEdit1ViewController = (segue.destination as? UserProfileEdit1ViewController)!
//            itemView.receive_user_name = self.receive_user_name
//            itemView.receive_user_email = self.email
            
            item.work_birth_day_year = api.profile.birth_day_year!
            item.work_birth_day_date = api.profile.birth_day_date!
            item.work_blood_type = api.profile.blood_type!
            item.work_id = api.profile.id
            
        } else if segue.identifier == "userProfileEdit2" {
            let item: UserProfileEdit2ViewController = (segue.destination as? UserProfileEdit2ViewController)!
            item.work_birth_place = api.profile.birth_place!
            item.work_id = api.profile.id
        }else if segue.identifier == "userProfileEdit3" {
            let item: UserProfileEdit3ViewController = (segue.destination as? UserProfileEdit3ViewController)!
            item.work_university_name = api.profile.university_name!
            item.work_university_subject = api.profile.university_subject!
            item.work_id = api.profile.id
        }else if segue.identifier == "userProfileEdit4" {
            let item: UserProfileEdit4ViewController = (segue.destination as? UserProfileEdit4ViewController)!
            item.work_propose_place = api.profile.propose_place!
            item.work_propose_word = api.profile.propose_word!
            item.work_id = api.profile.id
            
        }else if segue.identifier == "userProfileEdit5" {
            let item: UserProfileEdit5ViewController = (segue.destination as? UserProfileEdit5ViewController)!
            
            item.work_user_image = self.profile_image
            item.work_last_name = api.profile.last_name!
            item.work_first_name = api.profile.first_name!
            item.work_watch_word = api.profile.watch_word!
            item.work_public_id = api.profile.image!
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        
        case 0:
            return 160
            
        case 1:
            return 50
            
        case 2:
            return 50
        case 3:
            return 100
            
        case 4:
            return 150
            
        case 5:
            return 400
        default :
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
            
        case 0:
            let cell = profileTable.dequeueReusableCell(withIdentifier: "item1") as! UserNameImageTableViewCell
            print(api.profile.user_name!)
            cell.user_name.text = api.profile.user_name!
            cell.user_image.image = profile_image
            cell.reloadInputViews()
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "item2") as! BirthdayTableViewCell
            //            cell.cellATextLabel.text = "CustomCellA"誕生日
            cell.birth_day.text = api.profile.birth_day_year! + "年" + api.profile.birth_day_date!
                
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "item3") as! BloodTypeTableViewCell
            //            cell.cellATextLabel.text = "CustomCellA"血液型
            cell.blood_type.text = api.profile.blood_type! + "型"
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "item4") as! BirthPlaceTableViewCell
            //            cell.cellATextLabel.text = "CustomCellA"出身
            cell.birth_place1.text = api.profile.birth_place
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "item5") as! UniversityTableViewCell
            //            cell.cellATextLabel.text = "CustomCellA"大学
            cell.university_name.text = api.profile.university_name
            cell.university_subject.text = api.profile.university_subject
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "item6") as! ProposeTableViewCell
            //            cell.cellATextLabel.text = "CustomCellA"プロポーズ
            cell.propose_place.text = api.profile.propose_place
            cell.propose_word.text = api.profile.propose_word
            cell.propose_word.isEditable = false
            return cell
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: "item1") as! BloodTypeTableViewCell
            //            cell.cellATextLabel.text = "CustomCellA"
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("edit1")
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "userProfileEdit5", sender: nil)
            break
        case 1:
            print("edit2")
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "userProfileEdit1", sender: nil)
            break
        case 2:
            print("edit3")
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "userProfileEdit1", sender: nil)
            break
        case 3:
            print("edit4")
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "userProfileEdit2", sender: nil)
            break
        case 4:
            print("edit5")
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "userProfileEdit3", sender: nil)
            break
        case 5:
            print("edit6")
            tableView.deselectRow(at: indexPath, animated: false)
            performSegue(withIdentifier: "userProfileEdit4", sender: nil)
            break
            
        default:
            break
        }
    }
    

}
