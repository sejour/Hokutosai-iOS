//
//  StandardTableViewCellData.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/25.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

protocol StandardTableViewCellData {
    
    var dataId: UInt { get }
    var dataImageUrl: String? { get }
    var dataTitle: String? { get }
    var dataSubTitle: String? { get }
    var dataDescription: String? { get }
    
}