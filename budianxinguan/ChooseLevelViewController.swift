//
//  ChooseLevelViewController.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/20.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit

class ChooseLevelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let backGroundImage:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: statusBarHeight, width: kScreenWidth, height: kScreenHeight - statusBarHeight))
        backGroundImage.image = UIImage.init(named: "chooseLevelBackGroundImage")
        self.view.addSubview(backGroundImage)
        let width:CGFloat = 100
        let height:CGFloat = 50
        let lowModelButton:UIButton = UIButton.init(type: .custom)
        lowModelButton.addTarget(self, action: #selector(lowModel(sender:)), for: .touchUpInside)
//        lowModelButton.setImage(UIImage.init(named: "lowModel"), for: .normal)
        lowModelButton.setTitle("简单模式", for: .normal)
        lowModelButton.backgroundColor = .lightGray
        lowModelButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        lowModelButton.center = CGPoint(x: self.view.frame.midX, y: backGroundImage.frame.height * 0.75)
        lowModelButton.layer.masksToBounds = true
        lowModelButton.layer.cornerRadius = 8
        self.view.addSubview(lowModelButton)
        
        let hightModelButton:UIButton = UIButton.init(type: .custom)
        hightModelButton.addTarget(self, action: #selector(highModel(sender:)), for: .touchUpInside)
//        hightModelButton.setImage(UIImage.init(named: "highModel"), for: .normal)
        hightModelButton.setTitle("困难模式", for: .normal)
        hightModelButton.backgroundColor = .lightGray
        hightModelButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        hightModelButton.center = CGPoint(x: self.view.frame.midX, y: lowModelButton.center.y + height + 10)
        hightModelButton.layer.masksToBounds = true
        hightModelButton.layer.cornerRadius = 8
        self.view.addSubview(hightModelButton)
        
        let customModelButton:UIButton = UIButton.init(type: .custom)
        customModelButton.addTarget(self, action: #selector(customModel(sender:)), for: .touchUpInside)
//        customModelButton.setImage(UIImage.init(named: "customModel"), for: .normal)
        customModelButton.setTitle("自定义模式", for: .normal)
        customModelButton.backgroundColor = .lightGray
        customModelButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        customModelButton.center = CGPoint(x: self.view.frame.midX, y: hightModelButton.center.y + height + 10)
        customModelButton.layer.masksToBounds = true
        customModelButton.layer.cornerRadius = 8
        self.view.addSubview(customModelButton)
        
        let rankingListButton:UIButton = UIButton.init(type: .custom)
        rankingListButton.addTarget(self, action: #selector(pushRankingList(sender:)), for: .touchUpInside)
//        rankingListButton.setImage(UIImage.init(named: "rankinglist"), for: .normal)
        rankingListButton.setTitle("排行榜", for: .normal)
        rankingListButton.backgroundColor = .lightGray
        rankingListButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        rankingListButton.center = CGPoint(x: self.view.frame.midX, y: customModelButton.center.y + height + 10)
        rankingListButton.layer.masksToBounds = true
        rankingListButton.layer.cornerRadius = 8
        self.view.addSubview(rankingListButton)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func lowModel(sender:UIButton) {
        let vc:MainViewController = MainViewController.init()
        vc.level = .low
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func highModel(sender:UIButton) {
        let vc:MainViewController = MainViewController.init()
        vc.level = .high
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushRankingList(sender:UIButton) {
        let vc:RankingListViewController = RankingListViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func customModel(sender:UIButton) {
        let alertController = UIAlertController(title: "自定义难度",
                                                message: "", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "列数（9～27）"
        }
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "病毒数（1～727）"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            let row = alertController.textFields!.first!.text!
            let virus = alertController.textFields!.last!.text!
            if row.count == 0 || virus.count == 0 {
                let alertController = UIAlertController(title: "请输入",
                message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let rowCout = Int(row)
            let virusCount = Int(virus)
            if rowCout! > 27 || rowCout! < 9{
                let alertController = UIAlertController(title: "请输入正确的列数",
                message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if virusCount! < 1 || virusCount! > 727 {
                let alertController = UIAlertController(title: "请输入正确的病毒数",
                message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let vc:MainViewController = MainViewController.init()
            vc.level = .custom
            vc.xmbdLayoutRow = rowCout!
            vc.virusTotalCount = virusCount!
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
