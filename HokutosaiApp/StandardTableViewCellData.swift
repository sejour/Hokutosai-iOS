//
//  StandardTableViewCellData.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/25.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

protocol StandardTableViewCellData {
    
    var imageUrl: String { get }
    var title: String { get }
    var subTitle: String { get }
    var description: String { get }
    
}