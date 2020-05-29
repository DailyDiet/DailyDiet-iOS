//
//  DietTableViewCell.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import FontAwesome_swift

class DietTableViewCell: UITableViewCell {

    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var topView: UIView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var moreButton: UIButton!
    
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var fiberLabel: UILabel!
    @IBOutlet var fatLabel: UILabel!
    @IBOutlet var calorieLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    var isExpand: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.makeTopRound()
        detailView.makeBottomRound()
        
        
        moreButton.setImage(UIImage.fontAwesomeIcon(name: .infoCircle, style: .regular, textColor: .black, size: CGSize(width: 25, height: 25)), for: .normal)
    }



}
