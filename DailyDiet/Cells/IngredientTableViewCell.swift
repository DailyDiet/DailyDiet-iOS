//
//  IngredientTableViewCell.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet var ingredientImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var preparationLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var gramAmountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
