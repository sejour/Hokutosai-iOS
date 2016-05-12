//
//  AssessmentTableViewCell.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/13.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

protocol AssessmentTableViewCellDelegate : class {
    
    func tappedOthersButton(assessmentId: UInt)
    
}

class AssessmentTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var scoreImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    
    var assessmentId: UInt!
    weak var delegate: AssessmentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tappedReportButton(sender: AnyObject) {
        self.delegate?.tappedOthersButton(self.assessmentId)
    }
    
    func changeData(assessment: Assessment) {
        self.assessmentId = assessment.assessmentId
        
        self.userNameLabel.text = assessment.user?.userName ?? "ゲスト"
        
        if let score = assessment.score where score >= 0 && score <= 5 {
            self.scoreImageView.image = SharedImage.scoreImage[Int(score)]
        }
        else {
            self.scoreImageView.image = SharedImage.scoreImage[0]
        }
        
        self.commentLabel.text = assessment.comment ?? ""
        
        if let datetime = assessment.datetime {
            self.datetimeLabel.text = NSDate.stringFromDate(datetime, format: "yyyy/MM/dd HH:mm")
        }
        else {
            self.datetimeLabel.text = "投稿時間不明"
        }
    }
    
}
