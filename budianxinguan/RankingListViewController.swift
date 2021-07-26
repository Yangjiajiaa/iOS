//
//  RankingListViewController.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/21.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit
import CoreData

class RankingListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    var tableView:UITableView = UITableView()
    var dataArray:NSMutableArray = NSMutableArray.init()
    var modelButton:UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .white
        self.fetchRankingList(level: .low)
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: navigationHeight, width: kScreenWidth, height: 100))
        titleLabel.text = "排行榜"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.view.addSubview(titleLabel)
        
        self.modelButton = UIButton.init(type: .custom)
        self.modelButton.addTarget(self, action: #selector(modelChange(sender:)), for: .touchUpInside)
//        self.modelButton.setImage(UIImage.init(named: "moreSelected"), for: .normal)
        self.modelButton.frame = CGRect(x: kScreenWidth - 150, y: titleLabel.frame.maxY - 30, width: 120, height: 30)
        self.modelButton.setTitle("简单模式▼", for: .normal)
        self.modelButton.backgroundColor = .lightGray
        self.modelButton.titleLabel?.textAlignment = .center
        self.view.addSubview(self.modelButton)
        
//        let imageView:UIImageView = UIImageView.init(frame: CGRect(x: self.modelButton.frame.maxX, y: self.modelButton.frame.origin.y, width: 30, height: 30))
//        imageView.image = UIImage.init(named: "moreSelected")
//        self.view.addSubview(imageView)
        
        self.tableView = UITableView.init(frame: CGRect(x: 50, y: titleLabel.frame.maxY, width: kScreenWidth - 100, height: 500), style: .plain)
        self.tableView.delegate = self
        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(RankingListTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }
    
    @objc func modelChange(sender:UIButton) {
        let alertController = UIAlertController(title: "榜单选择",
        message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let lowAction = UIAlertAction(title: "简单模式", style: .default, handler: {
            action in
            self.modelButton.setTitle("简单模式▼", for: .normal)
            self.fetchRankingList(level: .low)
            self.tableView.reloadData()
        })
        let highAction = UIAlertAction(title: "困难模式", style: .default, handler: {
            action in
            self.modelButton.setTitle("困难模式▼", for: .normal)
            self.fetchRankingList(level: .high)
            self.tableView.reloadData()
        })
        let customAction = UIAlertAction(title: "自定义模式", style: .default, handler: {
            action in
            self.modelButton.setTitle("自定义模式▼", for: .normal)
            self.fetchRankingList(level: .custom)
            self.tableView.reloadData()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(lowAction)
        alertController.addAction(highAction)
        alertController.addAction(customAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func fetchRankingList(level:riskLevel) {
        let fetchRequest: NSFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let levelInt = Int64(Int(Float(level.rawValue)))
        fetchRequest.predicate = NSPredicate(format: "self.levelModel == %d", levelInt)
        let sort:NSSortDescriptor = NSSortDescriptor(key: "times", ascending: true)
        fetchRequest.sortDescriptors = [sort]
//        fetchRequest.fetchOffset = request.fetchOffset
//        fetchRequest.fetchLimit = request.fetchLimit
        do {
            let results = try CoreDataStore.managedObjectContext!.fetch(fetchRequest)
            self.dataArray = NSMutableArray.init(array: results)
        } catch let error {
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray.count > 10 {
            return self.dataArray.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RankingListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingListTableViewCell
        if indexPath.row < self.dataArray.count {
            let userData:User = self.dataArray[indexPath.row] as! User
            cell.prepareData(index: indexPath.row + 1, name: userData.name!, times: NSInteger(userData.times))
        } else {
            cell.prepareData(index: indexPath.row + 1, name: "null", times: 999)
        }
        return cell
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
