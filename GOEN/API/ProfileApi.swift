//
//  ProfileApi.swift
//  GOEN
//
//  Created by 木村猛 on 2017/12/07.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import Foundation
import Cloudinary
import Alamofire
import SwiftyJSON
import UIKit

public extension Notification.Name {
    public static let profileApiLoadStart = Notification.Name("ProfileApiLoadStart")
    public static let profileApiLoadComplate = Notification.Name("ProfileApiLoadComplate")
}

class ProfileApi {
    
    let apiHost = Bundle.main.object(forInfoDictionaryKey: "ApiHost") as! String
    var error_flg:Bool = false
    
    public var profile: Profile = Profile()
    public var public_id: String = ""
    
    func getUserProfile() {
        
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .profileApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/user_profile/show")!
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
                    self.profile.first_name = json["first_name"].string!
                    self.profile.last_name = json["last_name"].string!
                    self.profile.user_name = json["first_name"].string! + " " + json["last_name"].string!
                    self.profile.watch_word = json["watch_word"].string!
                    self.profile.id = json["id"].int!
                    if json["image"].string != nil {
                        
                        self.profile.image = json["image"].string!
                    }
                    
                    if json["user_profile"]["propose_place"].string != nil {
                        
                        self.profile.propose_place = json["user_profile"]["propose_place"].string!
                    }
                    if json["user_profile"]["blood_type"].string != nil {
                        
                        self.profile.blood_type = json["user_profile"]["blood_type"].string!
                    }
                    self.profile.id = json["user_profile"]["id"].int!
                    if json["user_profile"]["propose_word"].string != nil {
                        
                        self.profile.propose_word = json["user_profile"]["propose_word"].string!
                    }
                    if json["user_profile"]["birth_day"].string != nil {
                        
                        let split = json["user_profile"]["birth_day"].string!.components(separatedBy: "/")
                        
                        self.profile.birth_day_year = split[0]
                        
                        self.profile.birth_day_date = split[1] + "月" + split[2] + "日"
                        
                    }
                    if json["user_profile"]["birth_place"].string != nil {
                        self.profile.birth_place = " 〒 " + json["user_profile"]["birth_place"].string!
                    }
                    
                    if json["user_profile"]["university_name"].string != nil {
                        self.profile.university_name = json["user_profile"]["university_name"].string!
                    }
                    
                    if json["user_profile"]["university_subject"].string != nil {
                        self.profile.university_subject = json["user_profile"]["university_subject"].string!
                    }
                }
                NotificationCenter.default.post(name: .profileApiLoadComplate, object: nil)
        }
    }
    
    func updateProfile1(id: Int, birth_day: String, blood_type: String) {
        
        self.error_flg = false
        NotificationCenter.default.post(name: .coupleAlbumApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/user_profile/update_1")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "id": String(id),
            "birth_day": birth_day,
            "blood_type": blood_type
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
                    
                }
                
                
                NotificationCenter.default.post(name: .profileApiLoadComplate, object: nil)
        }
    }
    func updateProfile2(birth_place: String, id: Int) {
        
        self.error_flg = false
        NotificationCenter.default.post(name: .coupleAlbumApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/user_profile/update_2")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "id": String(id),
            "birth_place": birth_place
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
                    
                }
                
                
                NotificationCenter.default.post(name: .profileApiLoadComplate, object: nil)
        }
        
    }
    func updateProfile3(id: Int,
                        university_name: String,
                        university_subject: String) {
        
        self.error_flg = false
        NotificationCenter.default.post(name: .coupleAlbumApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/user_profile/update_3")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "id": String(id),
            "university_name": university_name,
            "university_subject": university_subject
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
                    
                }
                
                
                NotificationCenter.default.post(name: .profileApiLoadComplate, object: nil)
        }
        
    }
    func updateProfile4(id: Int,
                        propose_place: String,
                        propose_word: String) {
        
        self.error_flg = false
        NotificationCenter.default.post(name: .coupleAlbumApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "user/user_profile/update_4")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "id": String(id),
            "propose_place": propose_place,
            "propose_word": propose_word
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
                    
                }
                
                
                NotificationCenter.default.post(name: .profileApiLoadComplate, object: nil)
        }
        
    }
    func updateProfile5(first_name: String,last_name: String,
                        watch_word: String,public_id: String) {
        
        NotificationCenter.default.post(name: .profileApiLoadStart, object: nil)
        let userDefault = UserDefaults.standard
        
        print("couple edit start3")
        let postUrl = URL(string: apiHost + "user/user_profile/update_5")!
        print(postUrl)
        let headers: HTTPHeaders = [
            "Content-Type":"Application/json",
            "access-token": userDefault.string(forKey: "access_token")!,
            "uid": userDefault.string(forKey: "uid")!,
            "client": userDefault.string(forKey: "client")!
        ]
        
        let params = [
            "first_name": first_name,
            "last_name": last_name,
            "watch_word": watch_word,
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
                }else if response.response!.statusCode == 200 {
                    print(json[0])
                    
                }else {
                    self.error_flg = true
                }
                
                
                NotificationCenter.default.post(name: .profileApiLoadComplate, object: nil)
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

}

public struct Profile {
    public var id: Int = 0
    public var birth_day_date: String? = "----"
    public var birth_day_year: String? = "----"
    public var blood_type: String? = "----"
    public var birth_place: String? = "----"
    public var university_name: String? = "----"
    public var university_subject: String? = "----"
    public var propose_place: String? = "----"
    public var propose_word: String? = "----"
    public var user_name: String? = ""
    public var first_name: String? = ""
    public var last_name: String? = ""
    public var watch_word: String? = ""
    public var image: String? = ""
}
