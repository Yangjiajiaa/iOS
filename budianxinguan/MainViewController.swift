//
//  MainViewController.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/19.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{
    var xmbdCollectionView:UICollectionView!
    var xmbdLayout:UICollectionViewFlowLayout!
    var allDataArray:[BdDataModel] = NSMutableArray() as! [BdDataModel]
    var level:riskLevel!
    var isGameOver:Bool = false
    var isStart:Bool = false
    var virusTotalCount:NSInteger = 0
    var xmbdLayoutRow:NSInteger = 9
    var timer:Timer!
    var randomVirusTimer:Timer!
    var randomNotVirusTimer:Timer!
    var currentTimes:NSInteger = 0
    var timeView:CountView!
    var remainingVirusCountView:CountView!
    var remainingVirusCount:NSInteger = 0
    var reStartButton:UIButton!
    var headView:UIView!
    var markButton:UIButton!
    var goldfinger_random_notVirus:UIButton!
    var goldfinger_random_virus:UIButton!
    var isMarkModel:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.prepareData(level: self.level)
        self.headViewUI()
        xmbdCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: self.headView.frame.maxY, width: self.view.frame.size.width, height: 450), collectionViewLayout: xmbdLayout)
        xmbdCollectionView.backgroundColor = .blue
        xmbdCollectionView.delegate = self
        xmbdCollectionView.dataSource = self
        xmbdCollectionView.register(VirusCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(xmbdCollectionView)
        self.footerViewUI()
        
        // Do any additional setup after loading the view.
    }
    
    func headViewUI() {
        self.headView = UIView.init(frame: CGRect(x: 0, y: navigationHeight, width: kScreenWidth, height: 100))
        self.headView.backgroundColor = .white
        self.view.addSubview(self.headView)
        
        self.remainingVirusCountView = CountView.init(frame: CGRect(x: 0, y: 0, width: 100, height: headView.frame.size.height))
        self.remainingVirusCountView.setCountNumber(count: self.virusTotalCount)
        self.headView.addSubview(self.remainingVirusCountView)
        
        self.reStartButton = UIButton.init(type: .custom)
        self.reStartButton.addTarget(self, action: #selector(reStart(sender:)), for: .touchUpInside)
        self.reStartButton.setImage(UIImage.init(named: "reStart_normal"), for: .normal)
        self.reStartButton.frame = CGRect(x: 20, y: 0, width: 100, height: 100)
        self.reStartButton.center = CGPoint(x: headView.frame.width / 2, y: headView.frame.height / 2)
        self.headView.addSubview(self.reStartButton)
        
        self.timeView = CountView.init(frame: CGRect(x: self.headView.frame.width - 20 - 100, y: 0, width: 100, height: headView.frame.size.height))
        self.timeView.setCountNumber(count: 0)
        self.headView.addSubview(self.timeView)
    }
    
    func footerViewUI() {
        let width = self.xmbdCollectionView.frame.maxX / 7
        
        let footerView:UIView = UIView.init(frame: CGRect(x: 0, y: self.xmbdCollectionView.frame.maxY, width: kScreenWidth, height: width))
        footerView.backgroundColor = .white
        self.view.addSubview(footerView)
        
        
        self.markButton = UIButton.init(type: .custom)
        self.markButton.addTarget(self, action: #selector(markSelect(sender:)), for: .touchUpInside)
        self.markButton.setImage(UIImage.init(named: "mark_off"), for: .normal)
        self.markButton.frame = CGRect(x: width, y: 0, width: width, height: width)
        footerView.addSubview(self.markButton)
        
        self.goldfinger_random_virus = UIButton.init(type: .custom)
        self.goldfinger_random_virus.addTarget(self, action: #selector(randomVirus(sender:)), for: .touchUpInside)
        self.goldfinger_random_virus.setImage(UIImage.init(named: "goldfinger_random_virus"), for: .normal)
        self.goldfinger_random_virus.frame = CGRect(x: width * 3, y: 0, width: width, height: width)
        footerView.addSubview(self.goldfinger_random_virus)
        
        self.goldfinger_random_notVirus = UIButton.init(type: .custom)
        self.goldfinger_random_notVirus.addTarget(self, action: #selector(randomNotVirus(sender:)), for: .touchUpInside)
        self.goldfinger_random_notVirus.setImage(UIImage.init(named: "goldfinger_random_notVirus"), for: .normal)
        self.goldfinger_random_notVirus.frame = CGRect(x: width * 5, y: 0, width: width, height: width)
        footerView.addSubview(self.goldfinger_random_notVirus)
        self.footerButtonEnable(enable: false)
    }
    
    func footerButtonEnable(enable:Bool) {
        self.markButton.isEnabled = enable
        self.goldfinger_random_notVirus.isEnabled = enable
        self.goldfinger_random_virus.isEnabled = enable
    }
    
    @objc func randomVirus(sender:UIButton) {
        sender.isEnabled = false
        var n:NSInteger = 0
        self.randomVirusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            n += 1
            if n == 30 {
                sender.isEnabled = true
                timer.invalidate()
            }
        }
        var tempArray:[BdDataModel] = NSMutableArray() as! [BdDataModel]
        var markCorrectVirus:NSInteger = 0
        
        for data in self.allDataArray {
            if data.dataStatus == .mark && data.isVirus {
                markCorrectVirus += 1
                if markCorrectVirus == self.virusTotalCount {
                    return
                }
            }
            if data.dataStatus == .unClicked && data.isVirus {
                tempArray.append(data)
            }
        }
        let temp:Int = Int(arc4random_uniform(UInt32(tempArray.count)))
        let data = tempArray[temp]
        if data.isVirus && data.dataStatus == .unClicked {
            data.dataStatus = .mark
            self.changeRemainingVirusCount(isAdd: false)
        }
        self.xmbdCollectionView.reloadData()
        self.checkWin()
    }
    
    @objc func randomNotVirus(sender:UIButton) {
        sender.isEnabled = false
        var n:NSInteger = 0
        self.randomNotVirusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            n += 1
            if n == 30 {
                sender.isEnabled = true
                timer.invalidate()
            }
        }
        var tempArray:[BdDataModel] = NSMutableArray() as! [BdDataModel]
        for data in self.allDataArray {
            if data.dataStatus == .unClicked && data.isVirus == false {
                tempArray.append(data)
            }
        }
        if tempArray.count == 0 {
            self.checkWin()
            return
        }
        let temp:Int = Int(arc4random_uniform(UInt32(tempArray.count)))
        let data = tempArray[temp]
        if data.dataStatus == .unClicked && data.isVirus == false {
            data.dataStatus = .clicked
            self.removeAroundEmptyTile(data: data)
        }
        self.xmbdCollectionView.reloadData()
        self.checkWin()
    }
    
    @objc func markSelect(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.markButton.setImage(UIImage.init(named: "mark_on"), for: .normal)
        } else {
            self.markButton.setImage(UIImage.init(named: "mark_off"), for: .normal)
        }
    }
    
    @objc func reStart(sender:UIButton) {
        sender.setImage(UIImage.init(named: "reStart_normal"), for: .normal)
        self.markButton.isSelected = false
        self.markButton.setImage(UIImage.init(named: "mark_off"), for: .normal)
        self.allDataArray.removeAll()
        self.isGameOver = false
        self.isStart = false
        self.remainingVirusCount = 0
        self.footerButtonEnable(enable: isStart)
        if (self.timer != nil) {
            self.timer.invalidate()
        }
        
        if self.randomVirusTimer != nil {
            self.randomVirusTimer.invalidate()
        }
        
        if self.randomNotVirusTimer != nil {
            self.randomNotVirusTimer.invalidate()
        }
        self.currentTimes = 0
        self.remainingVirusCountView.setCountNumber(count: self.virusTotalCount)
        self.timeView.setCountNumber(count: 0)
        self.prepareData(level: self.level)
        self.xmbdCollectionView.reloadData()
        self.xmbdCollectionView.isUserInteractionEnabled = true
    }
    
    func prepareData(level:riskLevel) {
        self.allDataArray = NSMutableArray.init() as! [BdDataModel]
        self.level = level
        
        xmbdLayout = UICollectionViewFlowLayout()
        xmbdLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        xmbdLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)//设置边距
        xmbdLayout.minimumLineSpacing = 0.0
        xmbdLayout.minimumInteritemSpacing = 0.0
        
        if  .high == self.level {
            self.virusTotalCount = 40
            self.xmbdLayoutRow = 18
            let maxCount:NSInteger = self.xmbdLayoutRow * self.xmbdLayoutRow
            for _ in 0..<maxCount {
                let data:BdDataModel = BdDataModel.init(status: .unClicked, virusCount: 0)
                self.allDataArray.append(data)
            }
        } else if .low == self.level {
            self.virusTotalCount = 10
            self.xmbdLayoutRow = 9
            let maxCount:NSInteger = self.xmbdLayoutRow * self.xmbdLayoutRow
            for _ in 0..<maxCount {
                let data:BdDataModel = BdDataModel.init(status: .unClicked, virusCount: 0)
                self.allDataArray.append(data)
            }
        } else {
            let maxCount:NSInteger = self.xmbdLayoutRow * self.xmbdLayoutRow
            for _ in 0..<maxCount {
                let data:BdDataModel = BdDataModel.init(status: .unClicked, virusCount: 0)
                self.allDataArray.append(data)
            }
        }
        xmbdLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/CGFloat(self.xmbdLayoutRow), height: 450/CGFloat(self.xmbdLayoutRow))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:VirusCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VirusCollectionViewCell
        let dataModel:BdDataModel = self.allDataArray[indexPath.row]
        cell.analyticModel(model: dataModel, gameEnd: self.isGameOver)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isStart == false {
            if self.markButton.isSelected {
                return
            }
            isStart = true
            self.footerButtonEnable(enable: isStart)
            self.createVirus(virus: self.virusTotalCount, currentIndex: indexPath.row)
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
        }
        let data:BdDataModel = self.allDataArray[indexPath.row]
        if self.markButton.isSelected {
            if data.dataStatus == .unClicked {
                data.dataStatus = .mark
                self.changeRemainingVirusCount(isAdd: false)
            } else if data.dataStatus == .mark {
                data.dataStatus = .unClicked
                self.changeRemainingVirusCount(isAdd: true)
            } else {
                return
            }
            collectionView.reloadData()
            self.checkWin()
            return
        }
        
        if data.dataStatus == .mark || data.dataStatus == .clicked {
            return
            
        } else if data.isVirus {
            data.isVirusOn = true
            self.isGameOver = true
            collectionView.isUserInteractionEnabled = false
            self.timer.invalidate()
        } else if data.dataStatus == .unClicked {
            data.dataStatus = .clicked
            self.removeAroundEmptyTile(data: data)
        }
        collectionView.reloadData()
        self.checkWin()
    }
    
    @objc func timeUpdate() {
        self.currentTimes += 1
        self.timeView.setCountNumber(count: self.currentTimes)
    }
    
    func createVirus(virus:NSInteger, currentIndex:NSInteger) {
        let array:NSMutableArray = NSMutableArray.init()
        var count = virus
        while count > 0 {
            let temp:Int = Int(arc4random_uniform(UInt32(self.allDataArray.count)))
            if array.contains(temp) || temp == currentIndex {
                continue
            } else {
                array.add(temp)
                count-=1
            }
        }
        for index in array {
            let data:BdDataModel = self.allDataArray[index as! Int]
            data.isVirus = true
        }
        var n:NSInteger = 0
        for data in self.allDataArray {
            if data.isVirus == false {
                data.virusCount = self.getNearbyVirus(currentIndex: n )
            }
            n += 1
        }
    }
    
    func getNearbyVirus(currentIndex:NSInteger) -> NSInteger {
        let top:NSInteger =  currentIndex - self.xmbdLayoutRow
        let down:NSInteger = currentIndex + self.xmbdLayoutRow
        let left:NSInteger = currentIndex - 1
        let right:NSInteger = currentIndex + 1
        var nearByVirusCount:NSInteger = 0
        var tempArray:[BdDataModel] = NSMutableArray.init() as! [BdDataModel]
        
        
        let haveTop:Bool = top >= 0
        let haveDown:Bool = down <= self.allDataArray.count - 1
        let haveRight = (right + self.xmbdLayoutRow) % self.xmbdLayoutRow != 0 && currentIndex != 0
        let haveLeft = (currentIndex + self.xmbdLayoutRow) % self.xmbdLayoutRow != 0 && currentIndex != self.allDataArray.count - 1
        print("currentIndex\(currentIndex)")
        //top
        if  haveTop {
            let data:BdDataModel = self.allDataArray[top]
            tempArray.append(data)
            if data.isVirus {
                nearByVirusCount += 1
                print("top:\(top)")
            }
        }
        //down
        if haveDown {
            let data:BdDataModel = self.allDataArray[down]
            tempArray.append(data)
            if data.isVirus {
                nearByVirusCount += 1
                print("down:\(down)")
            }
        }
        //left
        if haveLeft {
            let data:BdDataModel = self.allDataArray[left]
            tempArray.append(data)
            if data.isVirus {
                nearByVirusCount += 1
                print("left:\(left)")
            }
            //left-top
            if haveTop {
                let data:BdDataModel = self.allDataArray[top - 1]
                tempArray.append(data)
                if data.isVirus {
                    nearByVirusCount += 1
                    print("left-top:\(top - 1)")
                }
            }
            //left-down
            if haveDown {
                let data:BdDataModel = self.allDataArray[down - 1]
                tempArray.append(data)
                if data.isVirus {
                    nearByVirusCount += 1
                    print("left-down:\(down - 1)")
                }
            }
        }
        //right
        if haveRight {
            let data:BdDataModel = self.allDataArray[right]
            tempArray.append(data)
            if data.isVirus {
                nearByVirusCount += 1
                print("right:\(right)")
            }
            //right-top
            if haveTop {
                let data:BdDataModel = self.allDataArray[top + 1]
                tempArray.append(data)
                if data.isVirus {
                    nearByVirusCount += 1
                    print("right-top:\(top + 1)")
                }
            }
            //right-down
            if haveDown {
                let data:BdDataModel = self.allDataArray[down + 1]
                tempArray.append(data)
                if data.isVirus {
                    nearByVirusCount += 1
                    print("right-down:\(down + 1)")
                }
            }
        }
        if nearByVirusCount == 0 {
            let currentData:BdDataModel = self.allDataArray[currentIndex]
            currentData.aroundIndexArray = tempArray
        }
        return nearByVirusCount
    }
    
    func removeAroundEmptyTile(data:BdDataModel) {
        let tempArray = data.aroundIndexArray
        for aroundData in tempArray {
            if aroundData.dataStatus == .unClicked {
                aroundData.dataStatus = .clicked
                self.removeAroundEmptyTile(data: aroundData)
            }
        }
    }
    
    func checkWin() {
        var markCorrectVirus:NSInteger = 0
        var unClickedCount:NSInteger = 0
        for data in self.allDataArray {
            if data.dataStatus == .mark && data.isVirus {
                markCorrectVirus += 1
            }
            if data.dataStatus == .unClicked {
                unClickedCount += 1
            }
        }
        
        if unClickedCount - self.remainingVirusCount == self.virusTotalCount {
            self.timer.invalidate()
            self.win()
        } else if markCorrectVirus == self.virusTotalCount && unClickedCount == 0 {
            self.timer.invalidate()
            self.win()
        }
    }
    
    func win() {
        let alertController = UIAlertController(title: "挑战成功",
                                                message: "耗时\(self.currentTimes)秒", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "用户名"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            action in
            self.reStart(sender:self.reStartButton)
        })
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            let name = alertController.textFields!.first!.text!
            self.saveResult(userName: name.count == 0 ? "null":name, times: self.currentTimes)
            self.reStart(sender:self.reStartButton)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeRemainingVirusCount(isAdd:Bool) {
        if isAdd {
            self.remainingVirusCount += 1
        } else {
            self.remainingVirusCount -= 1
        }
        self.remainingVirusCountView.setCountNumber(count: self.virusTotalCount + self.remainingVirusCount)
    }
    
    func saveResult(userName:String, times:NSInteger){
        
        let context = CoreDataStore.managedObjectContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context!)as! User
        
        user.name = userName
        
        user.times = Int64(times)
        
        user.levelModel = Int64(Int(Float(self.level!.rawValue)))
        
        do {
            try context!.save()
            
            print("保存成功")
            
        }catch let error{
            print("context can't save!, Error:\(error)")
            
        }
        
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
