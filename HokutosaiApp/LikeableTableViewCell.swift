//
//  LikeableTableViewCell.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/01.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

protocol LikeableTableViewCell {
    
    func updateLikes(dataId: UInt) -> Void
    
}