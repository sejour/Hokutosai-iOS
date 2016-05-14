//
//  StarScoreField.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/14.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol StarScoreFieldDelegate: class {
    
    func changeScore(score: UInt?)
    
}

class StarScoreField: UIView {

    var starIcons: [UIImageView]!
    
    weak var delegate: StarScoreFieldDelegate?
    
    private static let viewHeight: CGFloat = 30.0
    private static let sideMargin: CGFloat = 40.0
    private static let scoreMax: Int = 5
    
    init(width: CGFloat, defaultScore: UInt?, delegate: StarScoreFieldDelegate?) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: StarScoreField.viewHeight))
        
        self.delegate = delegate
        
        let score = Int(defaultScore ?? 0)
        
        let iconWidth = (width - (2 * StarScoreField.sideMargin)) / CGFloat(StarScoreField.scoreMax)
        
        self.starIcons = [UIImageView]()
        var starIconFrame = CGRect(x: 0.0, y: 0.0, width: iconWidth, height: StarScoreField.viewHeight)
        for i in 0 ..< StarScoreField.scoreMax {
            starIconFrame.origin.x = StarScoreField.sideMargin + (CGFloat(i) * iconWidth)
            let starIcon = UIImageView(frame: starIconFrame)
            starIcon.tag = i
            starIcon.contentMode = .ScaleAspectFit
            starIcon.image = i < score ? SharedImage.brightStarIcon : SharedImage.grayStarIcon
            starIcon.userInteractionEnabled = true
            starIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StarScoreField.tappedStarIcon(_:))))
            self.addSubview(starIcon)
            self.starIcons.append(starIcon)
        }
        
        self.snp_makeConstraints { make in
            make.width.equalTo(self.width)
            make.height.equalTo(self.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tappedStarIcon(gesture: UITapGestureRecognizer) {
        guard let icon = gesture.view as? UIImageView else { return }
        let score = icon.tag + 1
        self.updateStarIcons(score)
        self.delegate?.changeScore(UInt(score))
    }
    
    private func updateStarIcons(score: Int) {
        for i in 0 ..< self.starIcons.count {
            self.starIcons[i].image = i < score ? SharedImage.brightStarIcon : SharedImage.grayStarIcon
        }
    }

}
