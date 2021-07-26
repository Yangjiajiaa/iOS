//
//  VirusCollectionViewCell.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/19.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit

class VirusCollectionViewCell: UICollectionViewCell {
    var image:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.self.width, height: self.contentView.frame.size.height))
            self.contentView.addSubview(self.image)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func analyticModel(model:BdDataModel, gameEnd:Bool) {
        if model.dataStatus == .unClicked {
            if gameEnd == true && model.isVirus == true {
                if model.isVirusOn {
                    self.image.image = UIImage.init(named: "virus_on")
                } else {
                    self.image.image = UIImage.init(named: "virus_off")
                }
                return
            }
            self.image.image = UIImage.init(named: "unClicked")
        } else if model.dataStatus == .clicked {
            self.image.image = UIImage.init(named: "clicked_\(String(model.virusCount))")
        } else if model.dataStatus == .mark {
            if gameEnd == true && model.isVirus == true {
                self.image.image = UIImage.init(named: "virus_off")
                return
            }
            self.image.image = UIImage.init(named: "virus_mark")
        }
    }
}
