//
//  CoupleScheduleDetailViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/08.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleScheduleDetailViewController: UIViewController {

    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var eventTag: UILabel!
    @IBOutlet weak var eventDetail: UILabel!
    let coupleScheduleApi = CoupleScheduleApi()
    var coupleSchedule: CoupleSchedule = CoupleSchedule()
    override func viewDidLoad() {
        super.viewDidLoad()
        eventName.text! = coupleSchedule.eventName!
        eventTime.text! = coupleSchedule.scheduleTime!
        let split = coupleSchedule.scheduleDate!.components(separatedBy: "/")
        
        eventDate.text! = split[0] + "年" + split[1] + "月" + split[2] + "日"
        eventPlace.text! = coupleSchedule.eventPlace!
        
        if coupleSchedule.eventTag == "1" {
            eventTag.text = "記念日"
        }else if coupleSchedule.eventTag == "2" {
            eventTag.text = "デート"
        }else if coupleSchedule.eventTag == "3" {
            eventTag.text = "打ち合わせ"
        }else if coupleSchedule.eventTag == "4" {
            eventTag.text = "結婚式"
        }
        eventDetail.numberOfLines = 0
        eventDetail.text = coupleSchedule.scheduleDetail
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "editSchedule" {
            let scheduleCreateview: CoupleScheduleCreateViewController = (segue.destination as? CoupleScheduleCreateViewController)!
            scheduleCreateview.create_update_flg = 2
            scheduleCreateview.sorceEventName = eventName.text!
            scheduleCreateview.sorceScheduleDate = coupleSchedule.scheduleDate!
            scheduleCreateview.sorceScheduleTime = eventTime.text!
            scheduleCreateview.sorceEventPlace = eventPlace.text!
            scheduleCreateview.sorceEventTag = eventTag.text!
            scheduleCreateview.sorceEventDetail = eventDetail.text!
            scheduleCreateview.sorceId = coupleSchedule.id
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editSchedule(_ sender: Any) {
        print("edit page")
    }
    @IBAction func deleteSchedule(_ sender: Any) {
        coupleScheduleApi.id = coupleSchedule.id
        let alert = UIAlertController(title:"スケジュールの削除", message: "削除しますが、よろしいですか？", preferredStyle: UIAlertControllerStyle.alert)
        let action1 = UIAlertAction(title: "削除", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            
            SVProgressHUD.show()
            NotificationCenter.default.addObserver(
                forName: .coupleScheduleApiLoadComplate,
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
                    
                    
                    if self.coupleScheduleApi.error_flg {
                        let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                        let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                            (action: UIAlertAction!) in
                            
                        })
                        alert.addAction(action1)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }else {
                        self.navigationController?.popViewController(animated: true)
                    }
                    NotificationCenter.default.removeObserver(self)
            })
            
            self.coupleScheduleApi.deleteSchedule()
            
        })
        let action2 = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
        })
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    

}
