//
//  AuthApi.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/09.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import UIKit

public extension Notification.Name {
    public static let authApiLoadStart = Notification.Name("AuthApiLoadSatrt")
    public static let authApiLoadComplate = Notification.Name("AuthApiLoadComplate")
}
class AuthApi: UIViewController {
    
    let apiHost = Bundle.main.object(forInfoDictionaryKey: "ApiHost") as! String
    public var errFlg: Bool = false
    public var serviceCdFlg: Bool = false
    func signUp(email: String, password:String , first_name:String, last_name:String, watch_word: String) -> Bool {
        errFlg = false
        // API 実行開始を通知
        NotificationCenter.default.post(name: .authApiLoadStart, object: nil)
        let authPostUrl = URL(string: apiHost + "auth")!
        let params = [
            "email": email,
            "password": password,
            "first_name": first_name,
            "last_name": last_name
        ]
        Alamofire.request(authPostUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON
            {
                            response in
                
                let json = SwiftyJSON.JSON(data: response.data!)
                print(json["status"].string!)
                
                if json["status"].string! == "error" {
                    
                    self.errFlg = true
                    print("ERRERERRRERRRR")
                    
                }else {
                    
                }
                
                NotificationCenter.default.post(name: .authApiLoadComplate, object: nil)
        }
        return errFlg
    }
    
    func signIn(email: String, password:String) {
        self.errFlg = false
        // API 実行開始を通知
        NotificationCenter.default.post(name: .authApiLoadStart, object: nil)
        let authPostUrl = URL(string: apiHost + "auth/sign_in")!
        let params = [
            "email": email,
            "password": password
        ]
        print("===JSON==")
        print(params)
        print("===JSON==")
        Alamofire.request(authPostUrl,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON
            {
                response in
                let json = SwiftyJSON.JSON(data: response.data!)
                
                if !json["errors"].isEmpty || json == nil {

                    self.errFlg = true
                    print("ERRERERRRERRRR")

                }else {
                    self.errFlg = false
                    let userdefault = UserDefaults.standard
                    
                    // http header setting
                    if let headers = response.response?.allHeaderFields as? [String: String]{
                        let access_token = headers["Access-Token"]
                        let uid = headers["Uid"]
                        let client = headers["Client"]
                        // ...
                        
                        print(access_token!)
                        print(uid!)
                        print(client!)
                        userdefault.set(access_token!, forKey: "access_token")
                        userdefault.set(uid!, forKey :"uid")
                        userdefault.set(client!, forKey :"client")
                    }
                    if let headers = response.response?.allHeaderFields as? [String: String]{
                        let access_token = headers["Access-Token"]
                        let uid = headers["Uid"]
                        let client = headers["Client"]
                        // ...
                        
                        print(access_token!)
                        print(uid!)
                        print(client!)
                    }
                    
                    userdefault.set(json["id"].int!, forKey: "user_id")
                    
                    print(self.errFlg)
                    
                    /*
                     ちゃんと元に戻せ
                     */
                    if json["service_masters"].isEmpty {
                        print("service is nil...")
                        self.serviceCdFlg = true
                    }else {
                        print(json)


                    }
                }
                
                NotificationCenter.default.post(name: .authApiLoadComplate, object: nil)
        }
        
    }
    
    func signout() {
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "auth/sign_out")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        Alamofire.request(authPostUrl,
                          method: .delete,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: header).responseJSON
            {
                response in
                print(response.response?.statusCode)
                if response.response?.statusCode != 404 {
                }
                
                
                NotificationCenter.default.post(name: .authApiLoadComplate, object: nil)
        }
        
    }
        
}
