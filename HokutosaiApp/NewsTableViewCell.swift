//
//  NewsTableViewCell.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/30.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import OAStackView
import SnapKit

class NewsTableViewCell: UITableViewCell, LikeableTableViewCell {
    
    var firstImageView: UIImageView!
    var newsContentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    var index: Int!
    var data: Article!
    
    weak var delegate: LikeableTableViewCellDelegate?
    
    private static let contentHeight: CGFloat = 80.0
    static let rowHeight: CGFloat = 81.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
        
        self.firstImageView = UIImageView()
        self.contentView.addSubview(self.firstImageView)
        self.firstImageView.hidden = true
        self.firstImageView.contentMode = .ScaleAspectFill
        self.firstImageView.clipsToBounds = true
        
        self.newsContentView = NSBundle.mainBundle().loadNibNamed("NewsTableViewCellContent", owner: self, options: nil).first as! UIView
        self.contentView.addSubview(self.newsContentView)
        self.newsContentView.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func changeData(index: Int, article: Article) {
        self.data = article
        self.index = index
        
        self.initLayout()
        
        self.titleLabel.text = article.title ?? "タイトル無し"
        
        if let relatedEvent = article.relatedEvent, let organizer = relatedEvent.title {
            self.titleLabel.text = organizer
        }
        else if let relatedShop = article.relatedShop, let organizer = relatedShop.name {
            self.titleLabel.text = organizer
        }
        else if let relatedExhibition = article.relatedExhibition, let organizer = relatedExhibition.title {
            self.titleLabel.text = organizer
        }
        else {
            self.organizerLabel.text = nil
        }
        
        if let datetime = article.datetime {
            self.datetimeLabel.text = NSDate.stringFromDate(datetime, format: "yyyy-MM-dd HH:mm")
        }
        else {
            self.datetimeLabel.text = nil
        }
        
        if let likesCount = article.likesCount {
            self.likesCountLabel.text = String(likesCount)
        }
        else {
            self.likesCountLabel.text = "0"
        }
        
        if let liked = article.liked where liked {
            self.likeButton.imageView?.image = SharedImage.redHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountRed
        }
        else {
            self.likeButton.imageView?.image = SharedImage.grayHertIcon
            self.likesCountLabel.textColor = SharedColor.likesCountGray
        }
        
        self.firstImageView.image = nil
        var contentViewLeft = self.contentView.snp_left
        if let imageUrl = article.medias?.first?.url, let url = NSURL(string: imageUrl) {
            contentViewLeft = self.firstImageView.snp_right
            self.firstImageView.hidden = false
            self.firstImageView.af_setImageWithURL(url)
            self.firstImageView.snp_makeConstraints { make in
                make.left.equalTo(self.contentView)
                make.top.equalTo(self.contentView)
                make.width.height.equalTo(NewsTableViewCell.contentHeight)
            }
        }
        
        self.newsContentView.snp_makeConstraints { make in
            make.left.equalTo(contentViewLeft)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.height.equalTo(NewsTableViewCell.contentHeight)
        }
    }
    
    private func initLayout() {
        self.firstImageView.hidden = true
        self.newsContentView.hidden = false
        self.firstImageView.snp_removeConstraints()
        self.newsContentView.snp_removeConstraints()
    }
    
    func updateLikes(dataId: UInt) {
        guard dataId == self.data.newsId else { return }
        
        if let likesCount = self.data.likesCount {
            self.likesCountLabel.text = String(likesCount)
        }
        else {
            self.likesCountLabel.text = "0"
        }
        
        if let liked = self.data.liked where liked {
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
