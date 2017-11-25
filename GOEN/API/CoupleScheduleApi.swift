//
//  CoupleScheduleApi.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/04.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import Foundation


import Alamofire
import SwiftyJSON

import UIKit

public extension Notification.Name {
    public static let coupleScheduleApiLoadStart = Notification.Name("CoupleScheduleApiLoadSatrt")
    public static let coupleScheduleApiLoadComplate = Notification.Name("CoupleScheduleApiLoadComplate")
}

class CoupleScheduleApi {
    
    let apiHost = Bundle.main.object(forInfoDictionaryKey: "ApiHost") as! String
    var error_flg:Bool = false
    
    var scheduleDate: Array<String> = []
    var schedule: Array<Array<CoupleSchedule>> = []
    var id:Int = 0
    
    func setCoupleSchedule(event_name:String, schedule_date:String,schedule_time:String,schedule_detail:String,event_place:String,event_tag:String,create_update_flg:Int) {
        
        NotificationCenter.default.post(name: .coupleScheduleApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/set_schedule")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "id": String(id) ,
            "event_name": event_name,
            "schedule_date": schedule_date,
            "schedule_time": schedule_time,
            "schedule_detail": schedule_detail,
            "event_place": event_place,
            "event_tag": event_tag,
            "create_update_flg": String(create_update_flg)
        ]
        Alamofire.request(authPostUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON
            {
                response in
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    let json = SwiftyJSON.JSON(data: response.data!)
                    print(json)
                    
                    
                }
                
                
                NotificationCenter.default.post(name: .coupleScheduleApiLoadComplate, object: nil)
        }
        
    }
    func getCoupleSchedule() {
        
        NotificationCenter.default.post(name: .coupleScheduleApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/get_schedules")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        Alamofire.request(authPostUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON
            {
                response in
                if response.response?.statusCode == 200 {
                    
                    self.schedule = []
                    self.scheduleDate = []
                    let json = SwiftyJSON.JSON(data: response.data!)
//                    print(json)
//                    for (key, item) in json {
//                        date = item["schedule_date"].string!
//                    }
                    var scheduleItem: Array<CoupleSchedule> = []
                    for i in 0..<json.count {
                        
                        var coupleSchedule = CoupleSchedule()
                        
                        if i == 0 {
                            coupleSchedule.id = json[i]["id"].int!
                            coupleSchedule.eventName = json[i]["event_name"].string!
                            coupleSchedule.scheduleTime = json[i]["schedule_time"].string!
                            coupleSchedule.scheduleDate = json[i]["schedule_date"].string!
                            coupleSchedule.scheduleDetail = json[i]["schedule_detail"].string!
                            coupleSchedule.eventPlace = json[i]["event_place"].string!
                            coupleSchedule.eventTag = json[i]["event_tag"].string!
                            self.scheduleDate.append(json[i]["schedule_date"].string!)
                            scheduleItem.append(coupleSchedule)
                            
                        }else {
                            
                            if json[i]["schedule_date"].string! != json[i - 1]["schedule_date"].string! {
                                print("違う")
                                print(json[i]["event_name"].string!)
                                self.scheduleDate.append(json[i]["schedule_date"].string!)
                                self.schedule.append(scheduleItem)
                                
                                scheduleItem.removeAll()
                                
                                
                                coupleSchedule.id = json[i]["id"].int!
                                coupleSchedule.eventName = json[i]["event_name"].string!
                                coupleSchedule.scheduleTime = json[i]["schedule_time"].string!
                                coupleSchedule.scheduleDate = json[i]["schedule_date"].string!
                                coupleSchedule.scheduleDetail = json[i]["schedule_detail"].string!
                                coupleSchedule.eventPlace = json[i]["event_place"].string!
                                coupleSchedule.eventTag = json[i]["event_tag"].string!
                                
                                scheduleItem.append(coupleSchedule)
                                
                            }else {
                                
                                coupleSchedule.id = json[i]["id"].int!
                                coupleSchedule.eventName = json[i]["event_name"].string!
                                coupleSchedule.scheduleTime = json[i]["schedule_time"].string!
                                coupleSchedule.scheduleDate = json[i]["schedule_date"].string!
                                coupleSchedule.scheduleDetail = json[i]["schedule_detail"].string!
                                coupleSchedule.eventPlace = json[i]["event_place"].string!
                                coupleSchedule.eventTag = json[i]["event_tag"].string!
                                
                                scheduleItem.append(coupleSchedule)
                            }
                            
                        }
                    }
                    self.schedule.append(scheduleItem)
                }else {
                    self.error_flg = true
                    
                    
                }
                
                
                NotificationCenter.default.post(name: .coupleScheduleApiLoadComplate, object: nil)
        }
    }
    func deleteSchedule(){
        NotificationCenter.default.post(name: .coupleScheduleApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/del_schedule")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "id": String(id)
        ]
        Alamofire.request(authPostUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON
            {
                response in
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    let json = SwiftyJSON.JSON(data: response.data!)
                    print(json)
                    
                    
                }
                
                
                NotificationCenter.default.post(name: .coupleScheduleApiLoadComplate, object: nil)
        }
        
    }
}


public struct CoupleSchedule {
    public var id: Int = 0
    public var eventName: String? = nil
    public var scheduleDate: String? = nil
    public var scheduleTime: String? = nil
    public var scheduleDetail: String? = nil
    public var eventPlace: String? = nil
    public var eventTag: String? = nil
}
