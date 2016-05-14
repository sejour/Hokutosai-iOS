//
//  MyAssessmentView.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/15.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol MyAssessmentViewDelegate: AssessmentTableViewCellDelegate {
    
    func tappedWrite()
    
}

class MyAssessmentView: UIView {

    var contentView: UIView?
    
    weak var delegate: MyAssessmentViewDelegate?
    
    private static let cellHeight: CGFloat = 81.0
    
    private var asessmentId: UInt?
    
    init(width: CGFloat, delegate: MyAssessmentViewDelegate) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: width, height: MyAssessmentView.cellHeight))
        
        self.delegate = delegate
        
        let loadingView = SimpleLoadingView(frame: self.frame)
        loadingView.backgroundColor = UIColor.whiteColor()
        self.addSubview(loadingView)
        self.contentView = loadingView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(myAssessment: Assessment?) {
        if let contentView = self.contentView {
            contentView.removeFromSuperview()
            self.contentView = nil
        }
        
        self.asessmentId = myAssessment?.assessmentId
        
        if let assessment = myAssessment {
            let myAssessmentCell = UINib(nibName: "AssessmentTableViewCell", bundle: nil).instantiateWithOwner(nil, options: nil).first as! AssessmentTableViewCell
            myAssessmentCell.changeData(assessment)
            myAssessmentCell.delegate = self.delegate
            myAssessmentCell.origin = CGPoint(x: 8.0, y: 0.0)
            myAssessmentCell.size = CGSize(width: self.width - 18.0, height: MyAssessmentView.cellHeight)
            myAssessmentCell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(MyAssessmentView.othersAction(_:))))
            self.addSubview(myAssessmentCell)
            self.height = MyAssessmentView.cellHeight
            self.contentView = myAssessmentCell
        }
        else {
            let writeAssessmentButton = ButtonView(width: self.width, text: "評価を書く", target: self, action: #selector(MyAssessmentView.tappedWrite))
            writeAssessmentButton.setNeedsLayout()
            writeAssessmentButton.layoutIfNeeded()
            self.addSubview(writeAssessmentButton)
            self.height = writeAssessmentButton.height
            self.contentView = writeAssessmentButton
        }
    }
    
    func tappedWrite() {
        self.delegate?.tappedWrite()
    }
    
    func othersAction(gesture: UITapGestureRecognizer) {
        guard gesture.state == .Began, let id = self.asessmentId else { return }
        self.delegate?.tappedOthersButton(id)
    }
    
}
