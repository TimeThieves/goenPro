//
//  CreateBookViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/02/13.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit
import SVProgressHUD

class CreateBookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var api: UserApi = UserApi()
    var loadObserver: NSObjectProtocol?
    var loadDataObserver: NSObjectProtocol?
    var tableView: UITableView = UITableView()
    
    let delBtn: UIButton = UIButton()
    
    public var list = [Book]()
    let cellId = "createBookCell"
    
    override func viewWillAppear(_ animated: Bool) {
        print("book appear!")
        
        super.viewWillAppear(true)
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.clickAddButton(_:)))
        
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
        tableView.register(CreateBookCell.self, forCellReuseIdentifier: self.cellId)
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(tableView)
        SVProgressHUD.show()
        
        
        self.loadObserver = NotificationCenter.default.addObserver(
            forName: .userApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
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
                self.list = self.api.user_book_list
                self.tableView.reloadData()
                self.tableView.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
        })
        
        api.getUserBook()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
        NotificationCenter.default.removeObserver(self.loadObserver!)
    }
    
    
    @objc func clickAddButton(_ sender: AnyObject) {
        print("add book")
        let viewCtl = CreateBookViewController()
        viewCtl.view.backgroundColor = .white
        present(viewCtl, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.api.user_book_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! CreateBookCell
        print("aaaaaaaa")
        cell.book = self.list[indexPath.row]
//        cell.indexPath.row = indexPath.row
        cell.delBtn.addTarget(self, action: #selector(self.del(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func relodaTableview() {
        print("aaaaaaaaadsfadfasdfa")
        print(self.list)
        self.tableView.reloadData()
        
    }
    
    @objc func del(_ sender: UIButton) {
        
        print("del")
        
        SVProgressHUD.show()
        loadDataObserver = NotificationCenter.default.addObserver(
            forName: .userApiLoadComplate,
            object: nil,
            queue: nil,
            using: {
                (notification) in
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
                if self.api.errFlg {
                    let alert = UIAlertController(title:"エラー", message: "エラーが発生しました。再度追加ボタンを押してください。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }else {
                    let alert = UIAlertController(title:"削除完了", message: "あなたの好きな本を削除しました。", preferredStyle: UIAlertControllerStyle.alert)
                    let action1 = UIAlertAction(title: "閉じる", style: UIAlertActionStyle.default, handler: {
                        (action: UIAlertAction!) in
                        self.tableView.reloadData()
                    })
                    alert.addAction(action1)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                SVProgressHUD.dismiss()
        })
        
        let cell = sender.superview as! CreateBookCell
        let row = self.tableView.indexPath(for: cell)?.row
        
        self.api.delUserBook(id: self.api.user_book_list[row!].id!)
    }

}

class CreateBookCell: UITableViewCell {
    var indexPath = IndexPath()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        
    }
    
    func setUpView() {
        itemName.frame = CGRect(x:0, y:0 , width: UIScreen.main.bounds.width, height: 25)
        delBtn.frame = CGRect(x:0, y: itemName.frame.height + 10 , width: 50, height: 25)
        addSubview(itemName)
        addSubview(delBtn)
        addConst()
    }
    func addConst() {
        //        user_img.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0).isActive = true
        //        user_img.heightAnchor.constraint(equalToConstant: 80.0)
        //
//        itemName.leadingAnchor.constraint(equalTo: .trailingAnchor, constant: 10.0).isActive = true
        //
        //        user_msg.topAnchor.constraint(equalTo: user_img.bottomAnchor, constant: 10.0).isActive = true
    }
    
    var itemName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    var delBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("削除", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.blue
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var book: Book = Book() {
        didSet {
            itemName.text = book.name!
        }
    }
}


