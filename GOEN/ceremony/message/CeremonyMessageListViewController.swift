//
//  CeremonyMessageListViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/31.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CeremonyMessageListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let cellId = "ceremonyMessageCell"
    let headerId = "header"
    var loadObserver: NSObjectProtocol?
    let cellMargin:CGFloat = 1.0
    
    public var couple_id: Int = 0
    let api: CoupleApi = CoupleApi()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("wwwwaaai")
        print(api.messageList.count)
        return self.api.messageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ceremonyMessageCell", for: indexPath) as! CeremonyMessageCollectionViewCell
        cell.message = self.api.messageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CeremonyMessageListHeaderCollectionViewCell
        header.messageMakeButton.addTarget(self, action: #selector(self.onClick(_:)), for: .touchUpInside)
        return header
    }
    
    @objc func onClick(_ sender: AnyObject){
        print(self.couple_id)
        // 遷移するViewを定義する.
        let view: CreateMessageViewController = CreateMessageViewController()
        view.couple_id = self.couple_id
//        view.couple_id = 0
        // アニメーションを設定する.
        view.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        // Viewの移動する.
        self.present(view, animated: true, completion: nil)
        
    }
    
//    // Segue 準備
//    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
//        if (segue.identifier == "messageCreateModal") {
//            guard let ModalVC = segue.destination as? CreateMessageViewController else {
//                return
//            }
//            
//            ModalVC.modalPresentationStyle = .overCurrentContext
//            ModalVC.view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.5)
//            
//        }
//    }
    
    private var ceremonyMessageCollection: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("test3")
        print(self.couple_id)
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        // レイアウト作成
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        // セクション毎のヘッダーサイズ
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width,height:1)
        flowLayout.sectionInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        // コレクションビュー作成
        ceremonyMessageCollection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        ceremonyMessageCollection.register(CeremonyMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        ceremonyMessageCollection.register(CeremonyMessageListHeaderCollectionViewCell.self,
                                           forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                           withReuseIdentifier: headerId)
        
        
        ceremonyMessageCollection.backgroundColor = UIColor.lightGray
        ceremonyMessageCollection.dataSource = self
        ceremonyMessageCollection.delegate = self
        ceremonyMessageCollection.alwaysBounceVertical = true
        ceremonyMessageCollection.translatesAutoresizingMaskIntoConstraints = false
        // AutoLayout制約を追加
        setupConstraints()
        self.view.addSubview(ceremonyMessageCollection)
        
        SVProgressHUD.show()
        loadObserver = NotificationCenter.default.addObserver(
            forName: .coupleApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
                print("ceremony API Load Complate!")
                
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
                
                SVProgressHUD.dismiss()
                
                self.ceremonyMessageCollection.reloadData()
        })
        
        api.getCoupleMessages(couple_id: self.couple_id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }
    
    private func setupConstraints(){
//        createMessageButton.topAnchor.constraint(equalTo: (navigationController?.view.bottomAnchor)!, constant: 0).isActive = true
//        createMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 375).isActive = true
        
//        ceremonyMessageCollection.topAnchor.constraint(equalTo: createMessageButton.bottomAnchor, constant: 8).isActive = true
        
        
    }
    /*
     
     Sectionの数
     
     */
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    //セルサイズ設定
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize{
        
        print("layout1000001")
        let numberOfMargin:CGFloat = 4.0
        let width:CGFloat = self.view.frame.width
        let height:CGFloat = 200.0
        return CGSize(width:width,height:height)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
