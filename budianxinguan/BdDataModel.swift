//
//  BdDataModel.swift
//  budianxinguan
//
//  Created by yjj on 2020/12/19.
//  Copyright © 2020 budianxinguan. All rights reserved.
//

import UIKit

class BdDataModel: NSObject {
    var dataStatus:status!
    var virusCount:NSInteger!
    var isVirus:Bool = false
    var isVirusOn:Bool = false
    var aroundIndexArray:[BdDataModel] = NSMutableArray() as! [BdDataModel]
    
    init(status:status, virusCount:NSInteger){
        self.dataStatus = status
        self.virusCount = virusCount
    }
}
