//
//  DirectionTableViewCell.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {

    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var detailLabelHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
