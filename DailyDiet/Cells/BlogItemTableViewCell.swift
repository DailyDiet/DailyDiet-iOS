//
//  BlogItemTableViewCell.swift
//  DailyDiet
//
//  Created by ali on 6/12/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring

class BlogItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var moreButton: DesignableButton!
    @IBOutlet weak var deleteButton: DesignableButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var summaryLabelHeight: NSLayoutConstraint!
    
    var isExpand: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
