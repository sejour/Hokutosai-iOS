//
//  StandardTableViewCell.swift
//  HokutosaiApp
//
//  Created by Shuka Takakuma on 2016/04/25.
//  Copyright © 2016年 Shuka Takakuma. All rights reserved.
//

import UIKit

class StandardTableViewCell: UITableViewCell {

    @IBOutlet weak var displayedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        self.titleLabel.text = data.dataTitle
        self.organizerLabel.text = data.dataOrganizer
        self.descriptionLabel.text = data.dataDescription
    }
    
    static let rowHeight: CGFloat = 81.0
    
}
