//
//  SearchFoodCollectionViewCell.swift
//  DailyDiet
//
//  Created by ali on 5/28/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring

class SearchFoodTableViewCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet weak var containerView: DesignableView!
    @IBOutlet var calorieLabel: UILabel!
    @IBOutlet var fatLabel: UILabel!
//    @IBOutlet var fiberLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
}
