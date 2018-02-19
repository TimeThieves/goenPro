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
    
    public var user_book_list = [Book]()
    public var user_food_list = [Food]()
    public var user_restaurant_list = [Restaurant]()
    public var user_hoby_list = [Hoby]()
    public var user_song_list = [Song]()
    public var user_ring_list = [Ring]()
    
    public var sys_err: Bool = false
    
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
    
    func getUserBook() {
        print("get service")
        let userdefault = UserDefaults.standard
        user_book_list = [Book]()
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        
        let authPostUrl = URL(string: apiHost + "user/user_book_list")!
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
                
                if json != nil {
                    for (_, item) in json {
                        var book = Book()
                        print(item["name"].string!)
                        book.name = item["name"].string!
                        book.id = item["id"].int!
                        
                        self.user_book_list.append(book)
                    }
                    print(self.serviceList2)
                }
                
                
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func getUserHoby() {
        print("get service")
        let userdefault = UserDefaults.standard
        user_hoby_list = [Hoby]()
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        
        let authPostUrl = URL(string: apiHost + "user/user_hoby_list")!
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
                    var array_item = Hoby()
                    for (_, item) in json {
                        array_item.name = item["name"].string!
                        array_item.id = item["id"].int!
                        
                        self.user_hoby_list.append(array_item)
                    }
                    print(self.serviceList2)
                }
                
                
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func getUserFood() {
        print("get service")
        let userdefault = UserDefaults.standard
        user_food_list = [Food]()
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        
        let authPostUrl = URL(string: apiHost + "user/user_food_list")!
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
                    var array_item = Food()
                    for (_, item) in json {
                        array_item.name = item["name"].string!
                        array_item.id = item["id"].int!
                        self.user_food_list.append(array_item)
                        
                    }
                }
                
                
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func getUserRestaurant() {
        print("get service")
        let userdefault = UserDefaults.standard
        user_restaurant_list = [Restaurant]()
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        
        let authPostUrl = URL(string: apiHost + "user/user_restaurant_list")!
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
                    var array_item = Restaurant()
                    for (_, item) in json {
                        array_item.name = item["name"].string!
                        array_item.id = item["id"].int!
                        self.user_restaurant_list.append(array_item)
                        
                    }
                }
                
                
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func getUserSong() {
        print("get service")
        let userdefault = UserDefaults.standard
        user_song_list = [Song]()
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        
        let authPostUrl = URL(string: apiHost + "user/user_song_list")!
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
                    var song = Song()
                    for (_, item) in json {
                        song.name! = item["name"].string!
                        song.id = item["id"].int!
                        self.user_song_list.append(song)
                        
                    }
                }
                
                
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func getUserRing() {
        print("get service")
        let userdefault = UserDefaults.standard
        user_ring_list = [Ring]()
        // API 実行開始を通知
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        
        let authPostUrl = URL(string: apiHost + "user/user_ring_list")!
        
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
                    var ring = Ring()
                    for (_, item) in json {
                        ring.name! = item["name"].string!
                        ring.id = item["id"].int!
                        self.user_ring_list.append(ring)
                        
                    }
                }
                
                
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    /*
     user detail profile insert
    */
    func setUserBook(name: String) {
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_book/create")!
        
        self.errFlg = false
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "name": name
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
                if response.response!.statusCode == 200 {
                    print("success")
                    self.errFlg = false
                }else {
                    print("error")
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func setUserHoby(name: String) {
        
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_hoby/create")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "name": name
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func setUserFood(name: String) {
        
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_food/create")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "name": name
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func setUserRestaurant(name: String) {
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_restaurant/create")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "name": name
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func setUserSong(name: String) {
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_song/create")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "name": name
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func setUserRing(name: String) {
        
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_ring/create")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "name": name
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    
    /*
    user derail profile delete
    */
    func delUserBook(id: Int) {
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_book/delete")!
        
        self.errFlg = false
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(id)
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
                if response.response!.statusCode == 200 {
                    print("success")
                    self.errFlg = false
                }else {
                    print("error")
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func delUserHoby(id: Int) {
        
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_hoby/delete")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(id)
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func delUserFood(id: Int) {
        
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_food/delete")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(id)
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func delUserRestaurant(id: Int) {
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_restaurant/delete")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(id)
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func delUserSong(id: Int) {
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_song/delete")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(id)
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
                }
                NotificationCenter.default.post(name: .userApiLoadComplate, object: nil)
        }
        
    }
    
    func delUserRing(id: Int) {
        
        self.errFlg = false
        
        NotificationCenter.default.post(name: .userApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        let postUrl = URL(string:
            apiHost + "user/user_ring/delete")!
        
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "id": String(id)
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
                if response.response!.statusCode == 200 {
                    
                    self.errFlg = false
                }else {
                    self.errFlg = true
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

public struct Book {
    public var id: Int? = 0
    public var name: String? = nil
}
public struct Food {
    public var id: Int? = 0
    public var name: String? = nil
}
public struct Hoby {
    public var id: Int? = 0
    public var name: String? = nil
}
public struct Restaurant {
    public var id: Int? = 0
    public var name: String? = nil
}
public struct Song {
    public var id: Int? = 0
    public var name: String? = nil
}
public struct Ring {
    public var id: Int? = 0
    public var name: String? = nil
}
