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
    public var couple = Couple()
    public var public_id: String = ""
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
                    print(json["send_user"][0]["first_name"].string! + " " + json["send_user"][0]["last_name"].string!)
//                    let couple = Couple(id: json["id"].int!, couple_house_zip: json["couple_house_zip"].string!, couple_name: json["couple_name"].string!, couple_image: json["couple_image"].string!, bride_date: json["bride_date"].string!)
                    
                    self.couple.id = json["id"].int!
                    self.couple.couple_image = json["couple_image"].string!
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
        
        let postUrl = URL(string: apiHost + "couples/" + String(couple_id) + "/couple_info_update")!
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
                          method: .get,
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
                    print(json["send_user"][0]["first_name"].string! + " " + json["send_user"][0]["last_name"].string!)
                    //                    let couple = Couple(id: json["id"].int!, couple_house_zip: json["couple_house_zip"].string!, couple_name: json["couple_name"].string!, couple_image: json["couple_image"].string!, bride_date: json["bride_date"].string!)
                    
                    self.couple.id = json["id"].int!
                    self.couple.couple_image = json["couple_image"].string!
                    self.couple.couple_house_zip =  json["couple_house_zip"].string!
                    self.couple.bride_date = json["bride_date"].string!
                    self.couple.send_user.name = json["send_user"][0]["first_name"].string! + " " + json["send_user"][0]["last_name"].string!
                    self.couple.receive_user.name = json["receive_user"][0]["first_name"].string! + " " + json["receive_user"][0]["last_name"].string!
                    
                    self.couple.couple_name = json["couple_name"].string!
                    
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
}


public struct Couple {
    public var id: Int = 0
    public var couple_house_zip: String? = nil
    public var couple_name: String? = nil
    public var couple_image:String? = nil
    public var bride_date: String? = nil
    public var send_user = UserInfo()
    public var receive_user = UserInfo()
}
