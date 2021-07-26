//
//  CountView.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/20.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit

class CountView: UIView {
    //百位
    var hundredsImageView:UIImageView!
    //十位
    var decadeImageView:UIImageView!
    //个位
    var unitImageView:UIImageView!
    
    var countNumber:NSInteger = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareView() {
        let width:CGFloat = self.frame.size.width / 3
        let height:CGFloat = self.frame.size.height * 0.6
        let y:CGFloat = self.frame.size.height * 0.2
        
        self.hundredsImageView = UIImageView.init(frame: CGRect(x: 0, y: y, width: width, height: height))
        self.decadeImageView = UIImageView.init(frame: CGRect(x: self.hundredsImageView.frame.maxX, y: y, width: width, height: height))
        self.unitImageView = UIImageView.init(frame: CGRect(x: self.decadeImageView.frame.maxX, y: y, width: width, height: height))
        
        self.addSubview(self.hundredsImageView)
        self.addSubview(decadeImageView)
        self.addSubview(unitImageView)
    }
    
    func setCountNumber(count:NSInteger) {
        self.countNumber = count
        if self.countNumber < 0 {
            self.countNumber = 0
        }
        let hundred:NSInteger = self.countNumber / 100
        let decade:NSInteger = self.countNumber % 100 / 10
        let unit:NSInteger = self.countNumber % 10
        self.hundredsImageView.image = UIImage.init(named: "count_\(hundred)")
        self.decadeImageView.image = UIImage.init(named: "count_\(decade)")
        self.unitImageView.image = UIImage.init(named: "count_\(unit)")
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
