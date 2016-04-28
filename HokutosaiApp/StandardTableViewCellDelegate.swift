//
//  StandardTableViewCellDelegate.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/28.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import Foundation

protocol StandardTableViewCellDelegate: class {
    
    func like(data: StandardTableViewCellData) -> Void
    
}