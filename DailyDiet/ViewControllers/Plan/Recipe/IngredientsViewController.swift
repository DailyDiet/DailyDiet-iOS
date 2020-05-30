//
//  IngrediemtsViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import SDWebImage

class IngredientsViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    
    var ingredientList: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        }

}


extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as! IngredientTableViewCell
        let cellData = ingredientList[indexPath.row]
        
        cell.nameLabel.text = cellData.food.foodName
        cell.amountLabel.text = "\(cellData.amount) \(cellData.units)"
        if let preparation = cellData.preparation {
        cell.preparationLabel.text = preparation
            cell.preparationLabel.isHidden = false
        } else {
            cell.preparationLabel.isHidden = true
        }
        cell.gramAmountLabel.text = "\(cellData.grams) grams"
        
        
        cell.ingredientImageView.sd_setImage(with: URL(string: cellData.food.primaryThumbnail))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
