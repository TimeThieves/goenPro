//
//  CeremonyInvitationMainViewController.swift
//  GOEN
//
//  Created by 木村猛 on 2018/01/15.
//  Copyright © 2018年 木村猛. All rights reserved.
//

import UIKit

class CeremonyInvitationMainViewController: UIViewController {
    
    @IBOutlet weak var inviSegment: UISegmentedControl!
    @IBOutlet var mybridalView: UIView!
    @IBOutlet var receiveInvitView: UIView!
    @IBOutlet var mainview: UIView!
    
    var containers: Array<UIView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("test4")
        mybridalView.frame = CGRect(x: 0,y: inviSegment.frame.minY + inviSegment.frame.height,width: self.view.frame.width, height: (self.view.frame.height - inviSegment.frame.minY))
        receiveInvitView.frame = CGRect(x: 0,y: inviSegment.frame.minY + inviSegment.frame.height,width: self.view.frame.width, height: (self.view.frame.height - inviSegment.frame.minY))
        self.view.addSubview(mybridalView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeContainerView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("test1")
            addFirstView()
        case 1:
            print("test2")
            addSecondView()
        default:
            print("test3")
            addFirstView()
        }
        
    }
    func addFirstView() {
        print("test6")
        receiveInvitView.removeFromSuperview()
        self.view.addSubview(mybridalView)
    }
    
    func addSecondView() {
        print("test7")
        mybridalView.removeFromSuperview()
        self.view.addSubview(receiveInvitView)
    }
    

}
