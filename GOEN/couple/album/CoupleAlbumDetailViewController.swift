//
//  CoupleAlbumDetailViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2017/11/19.
//  Copyright © 2017年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CoupleAlbumDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var noImageDialog: Bool = false
    var navTitle: String = ""
    var coupleAlbum: CoupleAlbum = CoupleAlbum()
    var loadObserver: NSObjectProtocol?
    
    @IBOutlet weak var collection: UICollectionView!
    let coupleAlbumApi = CoupleAlbumApi()
    
    let ipc = UIImagePickerController()
    
    var albumImage: UIImage = UIImage()
    
    var album_id:Int = 0
    
    @IBOutlet weak var titleName: UINavigationItem!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (coupleAlbum.image_list?.count)!
    }
    
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //レイアウト調整 行間余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat{
        return 5
    }
    
    //レイアウト調整　列間余白
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
        return 5
    }
    //選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertView = UIAlertController(title: "削除",
                                          message: "アルバムから写真を外しますか？",
                                          preferredStyle: .alert)
        let action1 = UIAlertAction(title: "削除する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.loadObserver = NotificationCenter.default.addObserver(
                forName: .coupleAlbumApiLoadComplate,
                object: nil,
                queue: nil,
                using: {
                    (notification) in
                    SVProgressHUD.dismiss()
                    print("API Load Complate!")
                    
                    if notification.userInfo != nil {
                        if let userinfo = notification.userInfo as? [String: String?] {
                            if userinfo["error"] != nil {
                                let alertView = UIAlertController(title: "通信エラー",
                                                                  message: "通信エラーが発生しました。",
                                                                  preferredStyle: .alert)
                                
                                alertView.addAction(
                                    UIAlertAction(title: "閉じる",
                                                  style: .default){
                                                    action in return
                                    }
                                )
                                self.present(alertView, animated: true,completion: nil)
                            }
                        }
                    }
                    
                    if self.coupleAlbumApi.error_flg {
                        let alert = UIAlertController(title:"データ不正", message: "データが不正です。もう一度入力してください", preferredStyle: UIAlertControllerStyle.alert)
                        let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                            (action: UIAlertAction!) in
                            
                        })
                        alert.addAction(action1)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }else {
                        self.collection.reloadData()
                    }
                    NotificationCenter.default.removeObserver(self.loadObserver!)
            })
            
            let image_id = self.coupleAlbum.image_list![indexPath.row].id
            let album_id = self.coupleAlbum.id
            
            self.coupleAlbumApi.deleteImage(image_id: image_id, album_id: album_id)
            
            
        })
        let action2 = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
        })
        alertView.addAction(action1)
        alertView.addAction(action2)
        self.present(alertView, animated: true,completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CoupleAlbumDetailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:"albumImage",for:indexPath as IndexPath) as! CoupleAlbumDetailCollectionViewCell
        
        print(coupleAlbum.image_list![indexPath.row])
        cell.album_image = coupleAlbum.image_list![indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleName.title = coupleAlbum.albumTitle!
        print("album id is ...")
        print(coupleAlbum)
        collection.delegate = self
        ipc.delegate = self
        ipc.allowsEditing = true
        if coupleAlbum.imageNum! <= 0 {
            if self.noImageDialog {
                
                let alertView = UIAlertController(title: "写真がありません",
                                                  message: "アルバムに写真がありません。追加してください",
                                                  preferredStyle: .alert)
                let action1 = UIAlertAction(title: "写真を撮る", style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction!) in
                    
                    self.ipc.sourceType = .camera
                    
                    self.present(self.ipc, animated: true,completion: nil)
                    
                })
                let action2 = UIAlertAction(title: "アルバムから追加", style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction!) in
                    
                    self.ipc.sourceType = .photoLibrary
                    
                    self.present(self.ipc, animated: true,completion: nil)
                    
                })
                let action3 = UIAlertAction(title: "アルバム一覧に戻る", style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                    
                })
                alertView.addAction(action1)
                alertView.addAction(action2)
                alertView.addAction(action3)
                self.present(alertView, animated: true,completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 選択された画像
        let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        print(selectImage!)
        self.albumImage = selectImage!
        self.dismiss(animated: true, completion: nil )
        
        
        performSegue(withIdentifier: "createAlbumImage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createAlbumImage" {
            print("prepare")
            let view: CoupleAlbumImageCreateViewController = (segue.destination as? CoupleAlbumImageCreateViewController)!
            
            view.fromPage = 1
            view.image = self.albumImage
            view.album_id = coupleAlbum.id
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func imageReg(_ sender: Any) {
        let alertView = UIAlertController(title: "写真の追加",
                                          message: "撮影した写真、またはアルバムから追加する。",
                                          preferredStyle: .alert)
        let action1 = UIAlertAction(title: "写真を撮る", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.ipc.sourceType = .camera
            
            self.present(self.ipc, animated: true,completion: nil)
            
        })
        let action2 = UIAlertAction(title: "アルバムから追加", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            self.ipc.sourceType = .photoLibrary
            
            self.present(self.ipc, animated: true,completion: nil)
            
        })
        let action3 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
        })
        alertView.addAction(action1)
        alertView.addAction(action2)
        alertView.addAction(action3)
        self.present(alertView, animated: true,completion: nil)
        
    }
    
    // MARK: - UIImagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ipc.dismiss(animated: true, completion: nil)
    }

}
