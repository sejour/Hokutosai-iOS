//
//  StandardTableViewCell.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/25.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit
import AlamofireImage

class StandardTableViewCell: UITableViewCell {

    @IBOutlet weak var displayedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    
    var data: StandardTableViewCellData?
    
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
    
    func updateData(data: StandardTableViewCellData) {
        self.data = data
        
        if let imageUrl = data.dataImageUrl, let url = NSURL(string: imageUrl) {
            self.displayedImageView.af_setImageWithURL(url, placeholderImage: SharedImage.noImage)
        }
        else {
            self.displayedImageView.image = SharedImage.noImage
        }
 
        self.titleLabel.text = data.dataTitle ?? "<<Unknown>>"
        self.organizerLabel.text = data.dataOrganizer
        self.descriptionLabel.text = data.dataDescription
        
        if let likesCount = data.dataLikesCount {
            self.likesCountLabel.text = String(likesCount)
        }
        else {
            self.likesCountLabel.text = "0"
        }
        
        if let liked = data.dataLiked where liked {
            self.likeButton.imageView?.image = SharedImage.redHertIcon
        }
        else {
            self.likeButton.imageView?.image = SharedImage.grayHertIcon
        }
    }
    
    @IBAction func like(sender: AnyObject) {
        
    }
    
    static let rowHeight: CGFloat = 81.0
    
}
