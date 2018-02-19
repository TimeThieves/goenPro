//
//  CopleApi.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/12.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import Foundation
import Cloudinary
import Alamofire
import SwiftyJSON
import UIKit

public extension Notification.Name {
    public static let coupleApiLoadStart = Notification.Name("CoupleApiLoadSatrt")
    public static let coupleApiLoadComplate = Notification.Name("COupleApiLoadComplate")
}
class CoupleApi {
    var error_code: String = ""
    let apiHost = Bundle.main.object(forInfoDictionaryKey: "ApiHost") as! String
    
    public var coupleInfo = [Couple]()
    public var user = [UserInfo]()
    public var messageList = [SendCoupleMessage]()
    public var couple = Couple()
    public var public_id: String = ""
    public var sys_err: Bool = false
    
    var error_flg:Bool = false
    public var no_partner: Bool = false
    public var couple_flg: Bool = false
    
    public var updateFlg: Bool = false
    
    public var no_ceremony: Bool = false
    
    func getCouple () {
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        
        let postUrl = URL(string: apiHost + "couple/show_couple/")!
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        Alamofire.request(postUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                
                if response.response!.statusCode == 403 {
                    print("couple error")
                    self.error_code = "403"
                }else if response.response!.statusCode == 200 {
                   print(json)
                    
                    self.couple.id = json["id"].int!
                    if json["couple_image"].string != nil {
                        self.couple.couple_image = json["couple_image"].string!
                        
                    }else {
                        self.couple.couple_image = "sample"
                    }
                    self.couple.couple_house_zip =  json["couple_house_zip"].string!
                    self.couple.bride_date = json["bride_date"].string!
                    self.couple.send_user.name = json["send_user"][0]["first_name"].string! + " " + json["send_user"][0]["last_name"].string!
                    self.couple.receive_user.name = json["receive_user"][0]["first_name"].string! + " " + json["receive_user"][0]["last_name"].string!
                    
                    self.couple.couple_name = json["couple_name"].string!
                    
                }
                
                
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
    }
    func updateCouple (couple_id: Int, bride_date: String, couple_house_zip: String,couple_name: String,public_id: String) {
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        
        print("couple edit start3")
        let postUrl = URL(string: apiHost + "couples/" + String(couple_id) + "/couple_info_update")!
        print(postUrl)
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "bride_date": bride_date,
            "couple_house_zip": couple_house_zip,
            "couple_name": couple_name,
            "public_id": public_id
        ]
        Alamofire.request(postUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                
                if response.response!.statusCode == 403 {
                    print("couple error")
                    self.error_code = "403"
                }else if response.response!.statusCode == 200 {
                    print(json[0])
                    print(json["send_user"][0]["first_name"].string! + " " + json["send_user"][0]["last_name"].string!)
                    //                    let couple = Couple(id: json["id"].int!, couple_house_zip: json["couple_house_zip"].string!, couple_name: json["couple_name"].string!, couple_image: json["couple_image"].string!, bride_date: json["bride_date"].string!)
                    
                    self.couple.id = json["id"].int!
                    self.couple.couple_image = json["couple_image"].string!
                    self.couple.couple_house_zip =  json["couple_house_zip"].string!
                    self.couple.bride_date = json["bride_date"].string!
                    self.couple.send_user.name = json["send_user"][0]["first_name"].string! + " " + json["send_user"][0]["last_name"].string!
                    self.couple.receive_user.name = json["receive_user"][0]["first_name"].string! + " " + json["receive_user"][0]["last_name"].string!
                    
                    self.couple.couple_name = json["couple_name"].string!
                    
                }else {
                    self.error_flg = true
                }
                
                
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
    }
    
    
    func uploadImage(image: Data) {
        let config = CLDConfiguration(cloudName: "hhblskk6i",apiKey: "915434123912862",apiSecret: "OY0l20vcuWILROpwGbNHG5hdcpI")
        let cloudinary = CLDCloudinary(configuration: config)
        let uploader = cloudinary.createUploader()
        print(image)
        NotificationCenter.default.post(name: .upimageStart, object: nil)
        
        uploader.signedUpload(data: image, params: nil, progress: nil, completionHandler: {
            (response, error) in
            print(error)
            print(response?.resultJson["public_id"]! as! String)
            self.public_id = response?.resultJson["public_id"]! as! String
            NotificationCenter.default.post(name: .upimageComplate, object: nil)
            // Handle respone
        })
        
    }
    
    func getPartnerInfo(email: String, watch_word: String) {
        
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        self.no_partner = false
        let postUrl = URL(string: apiHost + "user/conf")!
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "email": email,
            "watch_word": watch_word
        ]
        Alamofire.request(postUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                
                if response.response!.statusCode == 402 {
                    print("couple error")
                    self.no_partner = true
                }else if response.response!.statusCode == 200 {
                    self.couple.receive_user.id = json[0]["id"].int!
                    self.couple.receive_user.first_name = json[0]["first_name"].string!
                    self.couple.receive_user.last_name = json[0]["last_name"].string!
                    self.couple.receive_user.email = json[0]["email"].string!
                    
                }
                
                
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
        
    }
    func getSendUserInfo(email: String, watch_word: String, send_user_id: Int) {
        
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        self.no_partner = false
        let postUrl = URL(string: apiHost + "user/send_user_conf")!
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "email": email,
            "watch_word": watch_word,
            "send_user_id": String(send_user_id)
        ]
        Alamofire.request(postUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                print(json)
                if response.response!.statusCode == 402 {
                    print("couple error")
                    self.no_partner = true
                }else if response.response!.statusCode == 200 {
                    self.couple.send_user.first_name = json["send_user"]["first_name"].string!
                    self.couple.send_user.last_name = json["send_user"]["last_name"].string!
                    self.couple.id = json["couple_info"]["id"].int!
                    self.couple.send_user.email = json["send_user"]["email"].string!
                    self.couple.propose_message = json["couple_info"]["propose_message"].string!
                    if  json["user_profile"]["image"].string != nil {
                        
                        self.couple.send_user.profile.image = json["user_profile"]["image"].string!
                    } else {
                        self.couple.send_user.profile.image = "sample"
                    }
                }
                
                
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
        
    }
    
    func setCoupleInfo (receive_user_id: Int,
                        couple_house_zip: String,
                        cohabitation_flg: Bool,
                        bride_date: String,
                        propose_message:String,
                        couple_name: String) {
        let userDefault = UserDefaults.standard
        
        var couple_id = userDefault.integer(forKey: "couple_id")
        print(couple_id)
        if couple_id != 0 {
            self.couple_flg = true
        }else {
            NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
            let userDefault = UserDefaults.standard
            self.no_partner = false
            let postUrl = URL(string: apiHost + "couples/tem_create")!
            let headers: HTTPHeaders = [
                "Content-Type":"Application/json",
                "access-token": userDefault.string(forKey: "access_token")!,
                "uid": userDefault.string(forKey: "uid")!,
                "client": userDefault.string(forKey: "client")!
            ]
            
            let params = [
                "receive_user_id": String(receive_user_id),
                "couple_house_zip": couple_house_zip,
                "cohabitation_flg": String(cohabitation_flg),
                "bride_date": bride_date,
                "propose_message": propose_message,
                "couple_name": couple_name
            ]
            Alamofire.request(postUrl,
                              method: .post,
                              parameters: params,
                              encoding: JSONEncoding.default,
                              headers: headers).responseJSON
                {
                    response in
                    
                    let json = SwiftyJSON.JSON(data: response.data!)
                    print(response.response!.statusCode)
                    if response.response!.statusCode == 402 {
                        print("couple error")
                        self.no_partner = true
                    }else if response.response!.statusCode == 200 {
                        
                        self.no_partner = false
                        
                    }
                    
                    
                    NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
            }
        }
    }
    
    func regFlgUpdate(coupleId: Int) {
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string: apiHost + "couples/reg_flg_update")!
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(coupleId)
        ]
        Alamofire.request(postUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                print(json)
                if response.response!.statusCode == 402 {
                    self.updateFlg = false
                }else if response.response!.statusCode == 200 {
                    self.updateFlg = true
                }
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
    }
    
    func getMyCoupleCeremonyInfo() {
        self.sys_err = false
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "ceremonies/" + String(userDefault.integer(forKey: "ceremony_id")) + "/ceremony_info")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        Alamofire.request(postUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                print(json)
                if(response.response) == nil {
                    self.sys_err = true
                    return
                    
                }
                if response.response!.statusCode == 403 {
                    self.no_ceremony = true
                }else if response.response!.statusCode == 200 {
                    self.no_ceremony = false
                    self.couple.ceremony_info.celemony_name = json["celemony_name"].string!
                    self.couple.ceremony_info.celemony_message = json["celemony_message"].string!
                }
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
    }
    
    func insertMessage(message: String, couple_id: Int) {
        self.sys_err = false
        self.updateFlg = false
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "couples/send_message")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "message_body": message,
            "couple_id": String(couple_id),
            "user_id": String(userDefault.integer(forKey: "user_id"))
            
        ]
        
        Alamofire.request(postUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                print(json)
                if(response.response) == nil {
                    self.sys_err = true
                    return
                    
                }
                if response.response!.statusCode == 403 {
                    self.no_ceremony = true
                }else if response.response!.statusCode == 200 {
                    self.no_ceremony = false
//                    self.couple.ceremony_info.celemony_name = json["celemony_name"].string!
//                    self.couple.ceremony_info.celemony_message = json["celemony_message"].string!
                }else {
                    self.updateFlg = true
                }
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
    }
    
    func getCoupleMessages(couple_id: Int) {
        self.sys_err = false
        NotificationCenter.default.post(name: .coupleApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        messageList = [SendCoupleMessage]()
        let postUrl = URL(string:
            apiHost + "couples/" + String(couple_id) + "/send_message_list")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        Alamofire.request(postUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                if(response.response) == nil {
                    self.sys_err = true
                    return
                    
                }
                if response.response!.statusCode == 403 {
                    self.no_ceremony = true
                }else if response.response!.statusCode == 200 {
                    print(json)
                    for (_, item) in json {
                        var sendMessageInfo = SendCoupleMessage()
                        sendMessageInfo.couple.ceremony_info.celemony_message = item["couple"]["ceremony_info"]["celemony_message"].string!
                        sendMessageInfo.couple.message_count = item["couple"]["message_count"].int!
                        sendMessageInfo.user.first_name = item["user"]["first_name"].string!
                        sendMessageInfo.user.last_name = item["user"]["last_name"].string!
//                        sendMessageInfo.user.image
                        sendMessageInfo.message.message_body = item["message"]["message_body"].string!
                        if item["user"]["image"].string == nil ||  item["user"]["image"].string == "" {
                            sendMessageInfo.user.image = "sample"
                        }else {
                            sendMessageInfo.user.image = item["user"]["image"].string!
                        }
                        self.messageList.append(sendMessageInfo)
                    }
                    print("wawai")
                    print(self.messageList)
                }
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
    }
}


public struct Couple {
    public var id: Int = 0
    public var message_count: Int = 0
    public var couple_house_zip: String? = nil
    public var couple_name: String? = nil
    public var couple_image:String? = nil
    public var bride_date: String? = nil
    public var send_user = UserInfo()
    public var receive_user = UserInfo()
    public var propose_message: String? = nil
    public var user_id: Int = 0
    public var ceremony_info = Ceremony()
}

public struct SendCoupleMessage {
    public var id: Int = 0
    public var couple: Couple = Couple()
    public var user: UserInfo = UserInfo()
    public var message: Message = Message()
    
}

public struct Message {
    public var id: Int = 0
    public var message_body: String? = nil
    
}
