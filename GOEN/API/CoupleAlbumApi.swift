//
//  CoupleAlbumApi.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/13.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import Foundation

import Cloudinary
import Alamofire
import SwiftyJSON
import UIKit

public extension Notification.Name {
    public static let coupleAlbumApiLoadStart = Notification.Name("CoupleAlbumApiLoadSatrt")
    public static let coupleAlbumApiLoadComplate = Notification.Name("CoupleAlbumApiLoadComplate")
    public static let upimageStart = Notification.Name("upimageSatrt")
    public static let upimageComplate = Notification.Name("upimageComplate")
}

class CoupleAlbumApi {
    
    let apiHost = Bundle.main.object(forInfoDictionaryKey: "ApiHost") as! String
    var error_flg:Bool = false
    
    var scheduleDate: Array<String> = []
    var album_list: Array<CoupleAlbum> = []
    var id:Int = 0
    var noImageFlg: Bool = false
    
    var public_id: String = ""
    //アルバム一覧のメソッド
    func setCoupleAlbum(title: String, couple_id: Int) {
        self.error_flg = false
        NotificationCenter.default.post(name: .coupleAlbumApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/create_album")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "title": title,
            "couple_id": String(couple_id)
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
                    
//                    for (_, item) in json {
//                        var album = CoupleAlbum()
//
//                        album.albumTitle = item["album"]["title"].string!
//                        let longDate = item["album"]["created_at"].string!
//                        var sortDate = longDate.substring(to: longDate.index(longDate.startIndex,offsetBy: 10))
//                        var spaCut = sortDate.split(separator: "-")
//                        album.created_at = spaCut[0] + "年" + spaCut[1] + "月" + spaCut[2] + "日"
//                        album.imageNum = item["album"]["album_image_count"].int
//
//                        if item["album"]["album_image_count"].int == 0 {
//                            self.noImageFlg = true
//                        }else {
//
//                            self.noImageFlg = false
//
//                        }
//                        album.id = item["album"]["id"].int
//
//
//                        self.album_list.append(album)
//
//                    }
                    
                }
                
                
                NotificationCenter.default.post(name: .coupleAlbumApiLoadComplate, object: nil)
        }
    }
    //アルバム取得のメソッド
    func getCoupleAlbum(couple_id: Int) {
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .coupleAlbumApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/" + String(couple_id) + "/get_couple_album_list")!
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
                    
                    for (_, item) in json {
                        var album = CoupleAlbum()
                        
                        album.albumTitle = item["album"]["title"].string!
                        let longDate = item["album"]["created_at"].string!
                        var sortDate = longDate.substring(to: longDate.index(longDate.startIndex,offsetBy: 10))
                        var spaCut = sortDate.split(separator: "-")
                        album.created_at = spaCut[0] + "年" + spaCut[1] + "月" + spaCut[2] + "日"
                        album.imageNum = item["album"]["album_image_count"].int
                        
                        if item["album"]["album_image_count"].int == 0 {
                            self.noImageFlg = true
                        }else {
                            
                            self.noImageFlg = false
                            
                        }
                        album.id = item["album"]["id"].int!
                        var list: Array<AlbumImages> = []
                        for(_,item2) in item["album"]["album_image_list"] {
                            var image = AlbumImages()
                            
                            image.public_id = item2["public_id"].string!
                            image.id = item2["id"].int!
                            image.image_name = item2["image_name"].string!
                            list.append(image)
                            
                        }
                        album.image_list = list
                        print(album.image_list!)
                        self.album_list.append(album)
                        
                    }
                }
                
                
                NotificationCenter.default.post(name: .coupleAlbumApiLoadComplate, object: nil)
        }
        
    }
    //アルバムに写真を追加するメソッド
    func setCoupleImageToAlbum(image_name: String, album_id: Int, public_id: String) {
        print("API START")
        self.error_flg = false
        NotificationCenter.default.post(name: .coupleAlbumApiLoadStart, object: nil)
        let userdefault = UserDefaults.standard
        let authPostUrl = URL(string: apiHost + "couples/" + String(album_id) + "/set_image_to_album")!
        let header: HTTPHeaders = [
            "access-token": userdefault.string(forKey: "access_token")!,
            "uid": userdefault.string(forKey: "uid")!,
            "client": userdefault.string(forKey: "client")!
        ]
        let params = [
            "image_name": image_name,
            "public_id": public_id
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
                    let json = SwiftyJSON.JSON(data: response.data!)
                    print(json)
                    
                    for (_, item) in json {
                        var album = CoupleAlbum()
                        
                        album.albumTitle = item["album"]["title"].string!
                        let longDate = item["album"]["created_at"].string!
                        let sortDate = longDate.substring(to: longDate.index(longDate.startIndex,offsetBy: 10))
                        var spaCut = sortDate.split(separator: "-")
                        album.created_at = spaCut[0] + "年" + spaCut[1] + "月" + spaCut[2] + "日"
                        album.imageNum = item["album"]["album_image_count"].int
                        
                        if item["album"]["album_image_count"].int == 0 {
                            self.noImageFlg = true
                        }else {
                            
                            self.noImageFlg = false
                            
                        }
                        self.album_list.append(album)
                        
                    }
                }
                
                
                NotificationCenter.default.post(name: .coupleAlbumApiLoadComplate, object: nil)
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

//        cloudinary.config().setValue("hhblskk6i", forKey: "cloud_name")
//        cloudinary.config().setValue("915434123912862", forKey: "api_key")
//        cloudinary.config().setValue("OY0l20vcuWILROpwGbNHG5hdcpI", forKey: "api_secret")
    
    }
}


public struct CoupleAlbum {
    public var id: Int = 0
    public var albumTitle: String? = nil
    public var created_at: String? = nil
    public var imageNum: Int? = 0
    public var image_list: Array<AlbumImages>? = []
}

public struct AlbumImages {
    public var id: Int = 0
    public var public_id: String? = nil
    public var image_name: String? = nil
}

