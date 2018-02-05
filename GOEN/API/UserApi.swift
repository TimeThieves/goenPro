//
//  User.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/17.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

import UIKit

public extension Notification.Name {
    public static let userApiLoadStart = Notification.Name("UserApiLoadSatrt")
    public static let userApiLoadComplate = Notification.Name("UserApiLoadComplate")
}
class UserApi: UIViewController {
    let apiHost = Bundle.main.object(forInfoDictionaryKey: "ApiHost") as! String
    public var errFlg: Bool = false
    public var signInErr: Bool = false
    public var serviceList1 = [Service]()
    public var serviceList2 = [Service]()
    public var couple_id:Int = 0
    public var receive_user_id:Int = 0
    public var send_user_id: Int = 0
    
    public var couple_info_exist_flg: Bool = false
    
    public var service_flg = false
    public var auth_flg = true
    
    public var couple_reg_flg: String = ""
    
    public var send_user_name: String = ""
    
    func getUserService() {
        
        serviceList1 = [Service]()
        errFlg = false
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        print (self.apiHost)
        let authPostUrl = URL(string: apiHost + "users/get_user_service")!
        let userdefault = UserDefaults.standard
        print(userdefault.string(forKey: "access_token")!)
        print(userdefault.string(forKey: "uid")!)
        print(userdefault.string(forKey: "client")!)
        
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
                userdefault.removeObject(forKey: "couple_id")
                userdefault.removeObject(forKey: "ceremony_id")
                let json = SwiftyJSON.JSON(data: response.data!)
                var service = Service()
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
                print(json)
                print("~~~~~~~~~~~~~~~~~~~~~~~~~~")
                if response.response == nil {
                    self.auth_flg = false
                    return
                }
                if response.response!.statusCode == 401 {
                    self.auth_flg = false
                }else {
                    self.auth_flg = true
                    for (_, item1) in json {
                        for (_,item2) in item1["service_masters"] {
                            
                            service.id = item2["id"].int!
                            service.service_cd = item2["service_cd"].string!
                            service.name = item2["name"].string!
        
                            self.serviceList1.append(service)
                        }
                        if(item1["couple_info"] != JSON.null) {
                            print(item1["couple_info"]["id"])
                            if item1["couple_info"]["id"].int != nil  {
                                userdefault.set(item1["couple_info"]["id"].int!, forKey: "couple_id")
                                self.couple_id = item1["couple_info"]["id"].int!
                                if item1["couple_info"]["reg_flg"].string! != "0" {
                                    
                                    self.couple_reg_flg = item1["couple_info"]["reg_flg"].string!
                                    
                                    print("=================")
                                    print(item1["couple_info"])
                                    print("=================")
                                    self.couple_info_exist_flg = true
                                    self.receive_user_id = item1["couple_info"]["receive_user_id"].int!
                                    self.send_user_id = item1["couple_info"]["send_user_id"].int!
                                    
                                    self.send_user_name = item1["send_user"]["first_name"].string! + " " + item1["send_user"]["last_name"].string!
                                }else {
                                    self.receive_user_id = item1["couple_info"]["receive_user_id"].int!
                                    self.send_user_name = item1["send_user"]["first_name"].string! + " " + item1["send_user"]["last_name"].string!
                                    self.send_user_id = item1["couple_info"]["send_user_id"].int!
                                    print(item1["couple_info"])
                                    self.couple_reg_flg = item1["couple_info"]["reg_flg"].string!
                                }
                                
                            }
                            
                        }
                        
                        if(item1["ceremony_info"] != JSON.null) {
                            print("ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg")
                            userdefault.set(item1["ceremony_info"]["id"].int!, forKey: "ceremony_id")
                        }
                    }
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
    }
    
    func getService() {
        print("get service")
        let userdefault = UserDefaults.standard
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let authPostUrl = URL(string: apiHost + "services")!
        print("test0002")
        print(userdefault.string(forKey: "access_token")!)
        print(userdefault.string(forKey: "uid")!)
        print(userdefault.string(forKey: "client")!)
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
                let json = SwiftyJSON.JSON(data: response.data!)
                print(json)
                
                if json != nil {
                    var service = Service()
                    for (key, item) in json {
                        
                        service.id = item["id"].int!
                        service.service_cd = item["service_cd"].string!
                        service.name = item["name"].string!
                        
                        
                        if service.service_cd?.substring(to: (service.service_cd?.index((service.service_cd?.startIndex)!,offsetBy:2))!) == "00" {
                            print("service cd1 = " + service.service_cd!)
                            service.reg_flg = true
                            self.serviceList1.append(service)
                        }else {
                            print("service cd2 = " + service.service_cd!)
                            service.reg_flg = false
                            self.serviceList2.append(service)
                        }
                        
                    }
                    print(self.serviceList2)
                }
                
                
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func setUserService(serviceList: [Service]) {
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "users/set_service")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        var parameters = [[String: String]]()
        var i: Int = 0
        for item in serviceList {
            var param = [String:String]()
            if !(item.reg_flg!) {
                continue
            }else {
                
                param = [
                    "id": String(item.id),
                    "name": item.name!,
                    "service_cd": item.service_cd!
                    ]
                
                parameters.append(param)
            }
            i = i + 1
        }
        Alamofire.request(authPostUrl,
                          method: .post,
                          parameters: ["service":parameters],
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON
            {
                response in
                print(response.response?.statusCode)
                if response.response?.statusCode != 404 {
                    self.service_flg = true
                }
                

                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
    }
    
}

public struct Service {
    public var id: Int = 0
    public var service_cd: String? = nil
    public var name: String? = nil
    public var reg_flg: Bool? = false
}

public struct UserInfo {
    public var id:Int = 0
    public var first_name: String? = nil
    public var last_name: String? = nil
    public var email: String? = nil
    public var name: String? = nil
    public var profile = Profile()
    public var image: String? = ""
    
}
