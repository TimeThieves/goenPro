//
//  Ceremony.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/02.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import Foundation
import Cloudinary
import Alamofire
import SwiftyJSON
import UIKit

public extension Notification.Name {
    public static let ceremonyApiLoadStart = Notification.Name("ceremonyApiLoadStart")
    public static let ceremonyApiLoadComplate = Notification.Name("ceremonyApiLoadComplate")
}

class CeremonyApi {
    let apiHost = Bundle.main.object(forInfoDictionaryKey: "ApiHost") as! String
    var error_flg:Bool = false
    
    public var ceremony: Ceremony = Ceremony()
    public var public_id: String = ""
    public var noImageFlg: Bool = false
    public var ceremonyList = [Ceremony]()
    
    public var invitationList = [Invite]()
    
    public var updateFlg: Bool = false
    public var ceremonyId: Int = 0
    
    public var user_list = [UserInfo]()
    public var ceremony_photo = [CeremonyPhoto]()
    public var user_info = UserInfo()
    public var ceremonyInfo: Ceremony = Ceremony()
    
    func getCeremonyList() {
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "ceremony/get_ceremony_list")!
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
                print("API START")
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    let json = SwiftyJSON.JSON(data: response.data!)
                    print(json)
                    for (_, item) in json {
                        print(item)
                        self.ceremony.celemony_name = item["celemony_name"].string
                        self.ceremony.celemony_holding_date = item["celemony_name"].string
                        self.ceremony.celemony_message = item["celemony_message"].string
                        // 挙式情報
                        if item["bride_place_name"].string != nil {
                            self.ceremony.bride_place_name = item["bride_place_name"].string
                            self.ceremony.bride_place_zip = item["bride_place_zip"].string
                            self.ceremony.bride_holding_time = item["bride_holding_time"].string
                            self.ceremony.bride_place_address = item["bride_place_address"].string
                            
                        }
                        // 披露宴情報
                        if item["reception_place_name"].string != nil {
                            self.ceremony.reception_place_name = item["reception_place_name"].string
                            self.ceremony.reception_place_zip = item["reception_place_zip"].string
                            self.ceremony.reception_holding_time = item["reception_holding_time"].string
                            self.ceremony.reception_place_address = item["reception_place_address"].string
                            
                        }
                        // 2次会情報
                        if item["scd_reception_place_name"].string != nil {
                            self.ceremony.scd_reception_place_name = item["scd_reception_place_name"].string
                            self.ceremony.scd_reception_place_zip = item["scd_reception_place_zip"].string
                            self.ceremony.scd_reception_holding_time = item["scd_reception_holding_time"].string
                            self.ceremony.scd_reception_place_address = item["scd_reception_place_address"].string
                            
                        }
                    }
                }
                
                
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
        
    }
    
    func setMyCeremony(celemony_name:String, celemony_holding_date:String,celemony_message: String,update_flg:Int){
        print(celemony_name)
        print(celemony_holding_date)
        print(celemony_message)
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        print("test")
        print(String(userDefault.integer(forKey: "couple_id")))
        let postUrl = URL(string: apiHost + "ceremonies/edit_ceremony_basic_info")!
        let headers: HTTPHeaders = [
            
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(userDefault.integer(forKey: "ceremony_id")),
            "celemony_name": celemony_name,
            "celemony_holding_date": celemony_holding_date,
            "celemony_message": celemony_message,
            "couple_id": String(userDefault.integer(forKey: "couple_id"))
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
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    }
    
    func getMyBridalInvitationUser() {
        
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/" + String(userdefault.integer(forKey: "couple_id")) + "/couple_invitation_user")!
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
                print("API START")
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    let json = SwiftyJSON.JSON(data: response.data!)
                    self.invitationList = [Invite]()
                    for (_, item) in json {
                        print(item)
                        var invite_info: Invite = Invite()
                        
                        invite_info.user_info.first_name = item["invite_user"]["first_name"].string!
                        invite_info.user_info.last_name = item["invite_user"]["last_name"].string!
                        invite_info.user_info.email = item["invite_user"]["email"].string!
                        if item["invite_user"]["image"].string == nil {
                            invite_info.user_info.image = "sample"
                        }else {
                            invite_info.user_info.image = item["invite_user"]["image"].string!
                        }
                        invite_info.reg_flg = item["reg_flg"].int!
                        self.invitationList.append(invite_info)
                    }
                }
                
                
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    }
    
    func getInvitationUserList() {
        
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/" + String(userdefault.integer(forKey: "couple_id")) + "/couple_invitation_user")!
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
                print("API START")
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    let json = SwiftyJSON.JSON(data: response.data!)
                    print(json)
                    for (_, item) in json {
                        print(item[])
                        
                    }
                }
                
                
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    }
    
    
    
    func getSearchInvitaionUser(first_name:String, last_name:String) {
        
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/user_list")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        
        let params = [
            "first_name": first_name,
            "last_name": last_name
        ]
        Alamofire.request(authPostUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON
            {
                response in
                print("API START")
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    self.user_list = []
                    let json = SwiftyJSON.JSON(data: response.data!)
                    for (_, item) in json {
                        var userInfo: UserInfo = UserInfo()
                        userInfo.first_name = item["first_name"].string!
                        userInfo.last_name = item["last_name"].string!
                        userInfo.id = item["id"].int!
                        
                        if item["image"].string == nil {
                            userInfo.image = "sample"
                        }else {
                            if item["image"].string! == "" {
                                userInfo.image = "sample"
                            }else {
                                
                                userInfo.image = item["image"].string!
                            }
                        }
                        self.user_list.append(userInfo)
                    }
                }
                
                
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    }
    
    
    func getInvitedUser() {
        
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/invited_user_list")!
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
                print("API START")
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    self.invitationList = [Invite]()
                    let json = SwiftyJSON.JSON(data: response.data!)
                    for (_, item) in json {
                        print(item)
                        var info: Invite = Invite()
                        info.id = item["id"].int!
                        info.user_info.first_name = item["user"]["first_name"].string!
                        info.user_info.last_name = item["user"]["last_name"].string!
                        info.user_info.id = item["user"]["id"].int!
                        info.couple_info.send_user.first_name = item["couple"]["send_user"][0]["first_name"].string!
                        info.couple_info.send_user.last_name = item["couple"]["send_user"][0]["last_name"].string!
                        
                        info.couple_info.receive_user.first_name = item["couple"]["receive_user"][0]["first_name"].string!
                        info.couple_info.receive_user.last_name = item["couple"]["receive_user"][0]["last_name"].string!
                        info.couple_info.id = item["couple"]["id"].int!
                        info.couple_info.ceremony_info.celemony_name = item["couple"]["ceremony_info"]["celemony_name"].string!
                        if item["couple"]["couple_image"].string == nil {
                            info.couple_info.couple_image = "sample"
                        }else {
                            if item["couple"]["couple_image"].string! == "" {
                                info.couple_info.couple_image = "sample"
                            }else {
                                
                                info.couple_info.couple_image = item["couple"]["couple_image"].string!
                            }
                        }
                        self.invitationList.append(info)
                    }
                }
                
                
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    }
    
    func getInviteUserDetail(id: Int) {
        
        
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/" + String(id) + "/invite_user_detail_info")!
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
                print("API START")
                if response.response?.statusCode != 200 {
                    
                    self.error_flg = true
                    
                }else {
                    let json = SwiftyJSON.JSON(data: response.data!)
                    print(json)
                    self.user_info.first_name = json["first_name"].string!
                    self.user_info.last_name = json["last_name"].string!
                    self.user_info.id = json["id"].int!
                    
                    if json["image"].string == nil {
                        self.user_info.image = "sample"
                    }else {
                        if json["image"].string! == "" {
                            self.user_info.image = "sample"
                            
                        }else {
                            
                            self.user_info.image = json["image"].string!
                        }
                    }
                    if json["user_profile"]["birth_place"].string == nil {
                        self.user_info.profile.birth_place = "設定なし"
                    }else{
                        self.user_info.profile.birth_place = json["user_profile"]["birth_place"].string!
                    }
                    if json["user_profile"]["university_name"].string == nil {
                        self.user_info.profile.university_name = "設定なし"
                    }else{
                        self.user_info.profile.university_name = json["user_profile"]["university_name"].string!
                    }
                }
                
                
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    }
    
    func setInviteUser(user_id:Int){
        
        self.error_flg = false
        
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string: apiHost + "user_invitation_ceremony")!
        let headers: HTTPHeaders = [
            
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(user_id),
            "couple_id": String(userDefault.integer(forKey: "couple_id")),
            "ceremony_id": String(userDefault.integer(forKey: "ceremony_id"))
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
                    self.error_flg = true
                }else if response.response!.statusCode == 200 {
                    self.error_flg = false
                }
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    }
    
    func setJoinCeremony(button_type: Int, invitation_id: Int) {
        
        self.error_flg = false
        
        NotificationCenter.default.post(name: .ceremonyApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string: apiHost + "user_invitation_update")!
        let headers: HTTPHeaders = [
            
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(invitation_id),
            "reg_flg": String(button_type)
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
                    self.error_flg = true
                }else if response.response!.statusCode == 200 {
                    self.error_flg = false
                }
                NotificationCenter.default.post(name: .ceremonyApiLoadComplate, object: nil)
        }
    
    }
}

public struct Ceremony {
    public var id: Int = 0
    public var celemony_name: String? = ""
    public var celemony_holding_date: String? = ""
    public var celemony_message: String? = ""
    public var bride_place_name: String? = ""
    public var bride_place_zip: String? = ""
    public var bride_place_address: String? = ""
    public var bride_holding_time: String? = ""
    public var reception_place_name: String? = ""
    public var reception_place_zip: String? = ""
    public var reception_place_address: String? = ""
    public var reception_holding_time: String? = ""
    public var scd_reception_place_name: String? = ""
    public var scd_reception_place_zip: String? = ""
    public var scd_reception_place_address: String? = ""
    public var scd_reception_holding_time: String? = ""
}

public struct Invite {
    public var id: Int = 0
    public var user_info = UserInfo()
    public var couple_info = Couple()
    public var reg_flg: Int = 0
    
}
