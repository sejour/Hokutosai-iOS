//
//  AssessmentAggregateView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/12.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class AssessmentAggregateView: UIView {
    
    static let viewHeight: CGFloat = 20.0
    static let scoreImageRatio: CGFloat = 173.0 / 30.0
    
    private var scoreImageView: UIImageView!
    private var scoreLabel: UILabel!
    private var countLabel: UILabel!
    
    convenience init(width: CGFloat, scoreData: AssessedScore) {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: AssessmentAggregateView.viewHeight), scoreData: scoreData)
    }
    
    init(frame: CGRect, scoreData: AssessedScore) {
        super.init(frame: frame)

        let count = scoreData.assessedCount ?? 0
        let totalScore = scoreData.totalScore ?? 0
        
        var score: Double?
        if count != 0 {
            score = Double(totalScore) / Double(count)
        }
        
        self.scoreImageView = UIImageView(image: SharedImage.scoreImage[Int(round(score ?? 0.0))])
        self.scoreImageView.contentMode = .ScaleAspectFit
        self.addSubview(self.scoreImageView)
        self.scoreImageView.snp_makeConstraints { make in
            make.left.equalTo(self).offset(20.0)
            make.top.equalTo(self)
            make.width.equalTo(AssessmentAggregateView.scoreImageRatio * AssessmentAggregateView.viewHeight)
            make.height.equalTo(AssessmentAggregateView.viewHeight)
        }
        
        self.scoreLabel = UILabel()
        self.scoreLabel.textColor = UIColor.grayColor()
        self.scoreLabel.font = UIFont.systemFontOfSize(15)
        self.scoreLabel.textAlignment = .Left
        self.scoreLabel.numberOfLines = 1
        self.scoreLabel.text = score != nil ? String(format: "(%.02f)", score!) : ""
        self.addSubview(self.scoreLabel)
        self.scoreLabel.snp_makeConstraints { make in
            make.left.equalTo(self.scoreImageView.snp_right).offset(8.0)
            make.top.equalTo(self)
            make.height.equalTo(AssessmentAggregateView.viewHeight)
        }
        
        self.countLabel = UILabel()
        self.countLabel.textColor = UIColor.grayColor()
        self.countLabel.font = UIFont.systemFontOfSize(15)
        self.countLabel.textAlignment = .Left
        self.countLabel.numberOfLines = 1
        self.countLabel.text = "評価件数: \(count)"
        self.addSubview(self.countLabel)
        self.countLabel.snp_makeConstraints { make in
            make.right.equalTo(self).offset(-20.0)
            make.top.equalTo(self)
            make.height.equalTo(AssessmentAggregateView.viewHeight)
        }
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(AssessmentAggregateView.viewHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}