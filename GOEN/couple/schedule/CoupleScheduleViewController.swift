//
//  CoupleScheduleViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/30.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleScheduleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let api = CoupleScheduleApi()
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadObserver: NSObjectProtocol?
    
    var didSelectItem: CoupleSchedule = CoupleSchedule()
    // セクションに含まれるデータの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < api.schedule.count {
            return api.schedule[section].count
            
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoupleScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CoupleScheduleCell")! as! CoupleScheduleTableViewCell
        
        cell.coupleSchedule = api.schedule[indexPath.section][indexPath.row]
        
        return cell
    }
    // Section数
    func numberOfSections(in tableView: UITableView) -> Int {
        print("section's count")
        print(api.scheduleDate.count)
        return api.scheduleDate.count
    }
    // Sectioのタイトル
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if section < api.scheduleDate.count {
            let stringDate = api.scheduleDate[section]
            let split = stringDate.components(separatedBy: "/")
            if split.count == 3 {
                
                print(split[0] + "年" + split[1] + "月" + split[2] + "日")
                return split[0] + "年" + split[1] + "月" + split[2] + "日"
            }
            
            return "9999年99月99日"
            
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.tableView.isUserInteractionEnabled = false
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .coupleScheduleApiLoadComplate,
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
                NotificationCenter.default.removeObserver(self)
        })
        
        api.getCoupleSchedule()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        didSelectItem = api.schedule[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "toDetail", sender: api.schedule[indexPath.section][indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail"{
            print(didSelectItem)
            let coupleDetail: CoupleScheduleDetailViewController = (segue.destination as? CoupleScheduleDetailViewController)!
            coupleDetail.coupleSchedule = didSelectItem
            
        } else if segue.identifier == "coupleCreate" {
            print(didSelectItem)
            let scheduleCreateview: CoupleScheduleCreateViewController = (segue.destination as? CoupleScheduleCreateViewController)!
            scheduleCreateview.create_update_flg = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createSchedule(_ sender: Any) {
        print("go to create schedule")
    }
    
}
