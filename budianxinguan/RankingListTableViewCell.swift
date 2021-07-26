//
//  RankingListTableViewCell.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/21.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit
import CoreData

class RankingListTableViewCell: UITableViewCell {
    var numberLabel:UILabel!
    var nameLabel:UILabel!
//    let levelLabel:UILabel!
    var timesLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.numberLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 50, height: self.contentView.frame.height))
        self.nameLabel = UILabel.init(frame: CGRect(x: self.numberLabel.frame.maxX, y: 0, width: 100, height: self.contentView.frame.height))
        self.timesLabel = UILabel.init(frame: CGRect(x: self.contentView.frame.width - 100 - 50, y: 0, width: 100, height: self.contentView.frame.height))
        
        self.numberLabel.textAlignment = .center
        self.nameLabel.textAlignment = .left
        self.timesLabel.textAlignment = .right
        
        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.timesLabel)
    }
    
    func prepareData(index:NSInteger, name:String, times:NSInteger) {
        self.numberLabel.text = "\(index)、"
        self.nameLabel.text = name
        self.timesLabel.text = "\(times)秒"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
