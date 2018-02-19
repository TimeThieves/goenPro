//
//  UserProfileDetailInfoViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/02/12.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class UserProfileDetailInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let detailItem: [String] = ["趣味","好きな本","好きな食べ物","おすすめレストラン","好きな曲","指輪"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        
        cell.titleName.text = detailItem[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            print("tach is waiwai")
            
            let view = CreateHobyListViewController()
            
            tableView.deselectRow(at: indexPath, animated: true)
//            self.present(CreateHobyViewController(), animated: true, completion: nil)
            if let nav = self.navigationController {
                nav.pushViewController(view, animated: true)
            } else {
                abort()
            }
            break
        case 1:
            let view = CreateBookListViewController()
            tableView.deselectRow(at: indexPath, animated: true)
            //            self.present(CreateHobyViewController(), animated: true, completion: nil)
            if let nav = self.navigationController {
                nav.pushViewController(view, animated: true)
            } else {
                abort()
            }
            
            break
        case 2:
            let view = CreateFoodListViewController()
            tableView.deselectRow(at: indexPath, animated: true)
            //            self.present(CreateHobyViewController(), animated: true, completion: nil)
            if let nav = self.navigationController {
                nav.pushViewController(view, animated: true)
            } else {
                abort()
            }
            break
        case 3:
            let view = CreateRestaurantListViewController()
            tableView.deselectRow(at: indexPath, animated: true)
            //            self.present(CreateHobyViewController(), animated: true, completion: nil)
            if let nav = self.navigationController {
                nav.pushViewController(view, animated: true)
            } else {
                abort()
            }
            break
        case 4:
            let view = CreateSongListViewController()
            tableView.deselectRow(at: indexPath, animated: true)
            //            self.present(CreateHobyViewController(), animated: true, completion: nil)
            if let nav = self.navigationController {
                nav.pushViewController(view, animated: true)
            } else {
                abort()
            }
            break
        case 5:
            let view = CreateRingListViewController()
            tableView.deselectRow(at: indexPath, animated: true)
            //            self.present(CreateHobyViewController(), animated: true, completion: nil)
            if let nav = self.navigationController {
                nav.pushViewController(view, animated: true)
            } else {
                abort()
            }
            break
        default:
            break
        }
    }
    
    var api: ProfileApi = ProfileApi()
    var loadDataObserver: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        self.view.backgroundColor = UIColor.lightGray
        
        let tableView = UITableView()
        
        tableView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "detailCell")
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.view.addSubview(tableView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.loadDataObserver != nil {
            NotificationCenter.default.removeObserver(self.loadDataObserver!)
            
        }
    }

}

class DetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setUpView()
        
    }
    
    func setUpView() {
        titleName.frame = CGRect(x:0, y:0 , width: UIScreen.main.bounds.width, height: 25)
        
        contentView.addSubview(titleName)
    }
    
    var titleName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
