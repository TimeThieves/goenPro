//
//  CopleApi.swift
//  GOEN
//
//  Created by 木村猛 on 2017/10/12.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import Foundation
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
                    
                }
                
                
                NotificationCenter.default.post(name: .coupleApiLoadComplate, object: nil)
        }
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
