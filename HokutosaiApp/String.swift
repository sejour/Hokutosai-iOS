//
//  String.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/14.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

extension String {
    
    var isBlank: Bool {
        return self.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet()).isEmpty
    }
    
}