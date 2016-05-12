//
//  AssessmentAggregateView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/12.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class AssessmentAggregateView: UIView {
    
    static let viewHeight: CGFloat = 18.0
    
    private var scoreImageView: UIImageView!
    private var scoreLabel: UILabel!
    private var countLabel: UILabel!
    
    convenience init(width: CGFloat, scoreData: AssessedScore) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 0.0), scoreData: scoreData)
    }
    
    init(frame: CGRect, scoreData: AssessedScore) {
        super.init(frame: frame)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}