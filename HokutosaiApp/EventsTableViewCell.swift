//
//  EventsTableViewCell.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/05/02.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell, LikeableTableViewCell {

    @IBOutlet weak var featuredIcon: UIImageView!
    @IBOutlet weak var illustrationView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateColorLine: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    var index: Int!
    var data: Event!
    weak var delegate: LikeableTableViewCellDelegate?
    
    static let rowHeight: CGFloat = 73.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeData(index: Int, data: Event) {
        self.index = index
        self.data = data
        
        if let featured = data.featured where featured {
            self.featuredIcon.hidden = false
        }
        else {
            self.featuredIcon.hidden = true
        }
        
        if let imageUrl = data.imageUrl, let url = NSURL(string: imageUrl) {
            self.illustrationView.af_setImageWithURL(url, placeholderImage: SharedImage.noImageWide)
        }
        else {
            self.illustrationView.image = SharedImage.noImageWide
        }

        self.titleLabel.text = data.title ?? "<<Unknown>>"
        self.datetimeLabel.text = data.holdDateTimeString
        
        let status = data.status
        self.stateLabel.text = status.text
        self.stateLabel.textColor = status.textColor
        self.stateColorLine.backgroundColor = status.lineColor
        
        if let likesCount = data.likesCount {
            self.likesCountLabel.text = String(likesCount)
        }
        else {
            self.likesCountLabel.text = "0"
        }
        
        if let liked = data.liked where liked {
            self.likeButton.imageView?.image = SharedImage.redHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountRed
        }
        else {
            self.likeButton.imageView?.image = SharedImage.grayHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountGray
        }
    }
    
    func updateLikes(dataId: UInt) {
        guard dataId == data.eventId else { return }
        
        if let likesCount = data.likesCount {
            self.likesCountLabel.text = String(likesCount)
        }
        else {
            self.likesCountLabel.text = "0"
        }
        
        if let liked = data.liked where liked {
            self.likeButton.imageView?.image = SharedImage.redHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountRed
        }
        else {
            self.likeButton.imageView?.image = SharedImage.grayHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountGray
        }
    }
    
    @IBAction func like(sender: AnyObject) {
        if let liked = self.data.liked where liked {
            self.likeButton.imageView?.image = SharedImage.grayHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountGray
            self.delegate?.dislike(self.index, cell: self)
        }
        else {
            self.likeButton.imageView?.image = SharedImage.redHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountRed
            self.delegate?.like(self.index, cell: self)
        }
    }
    
}
