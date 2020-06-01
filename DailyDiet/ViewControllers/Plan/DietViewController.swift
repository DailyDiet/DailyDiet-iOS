//
//  PlanResultViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import SwiftyJSON
import FontAwesome_swift

class DietViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    static var dietList: [DietElement] = [
        DietElement(id: 412923, category: "breakfast", image: "https://images.eatthismuch.com/site_media/img/412923_simmyras_ddc29085-a105-4a41-b99c-66c4d070afab.png", thumbnail: "https://images.eatthismuch.com/site_media/thmb/412923_simmyras_ddc29085-a105-4a41-b99c-66c4d070afab.png", title: "Greek Yogurt and Berry Parfait", nutrition: DietNutrition(calories: 344, fat: 10.6, fiber: 5.5, protein: 29.2)),
        DietElement(id: 45429, category: "appetizers", image: "https://images.eatthismuch.com/site_media/img/45429_Shamarie84_dbb8c936-5488-44ca-b915-8b1771725f0f.png", thumbnail: "https://images.eatthismuch.com/site_media/thmb/45429_Shamarie84_dbb8c936-5488-44ca-b915-8b1771725f0f.png", title: "Fried Mozzarella Balls", nutrition: DietNutrition(calories: 3952, fat: 405.1, fiber: 3.6, protein: 50.4))
    ]
    var heightList: [CGFloat] = []
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<DietViewController.dietList.count {
            heightList.append(265)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow(at: selectedIndex, animated: false)
        tableView.reloadData()
    }
    
    
    @IBAction func moreButtonDidTap(_ sender: UIButton) {
        let cell = (tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! DietTableViewCell)
        if cell.isExpand {
            cell.isExpand = false
            self.heightList[sender.tag] = 265
            cell.detailViewHeight.constant = 0
            UIView.animate(withDuration: 0.5) {

                cell.detailView.isHidden = true
            }
            
        } else {
            cell.isExpand = true
            cell.detailViewHeight.constant = 100
            self.heightList[sender.tag] = 370
            UIView.animate(withDuration: 1) {
                cell.detailView.isHidden = false
            }

            
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
}


extension DietViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DietViewController.dietList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietTableViewCell", for: indexPath) as! DietTableViewCell
        let cellData = DietViewController.dietList[indexPath.row]
        cell.moreButton.setImage(UIImage.fontAwesomeIcon(name: .infoCircle, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)), for: .normal)
        
        cell.nameLabel.text = cellData.title
        cell.foodImageView.sd_setImage(with: URL(string: cellData.thumbnail))
        
        cell.calorieLabel.text = "\(cellData.nutrition.calories) Calories"
        cell.fatLabel.text = "\(cellData.nutrition.fat)"
        cell.fiberLabel.text = "\(cellData.nutrition.fiber)"
        cell.proteinLabel.text = "\(cellData.nutrition.protein)"
        
        cell.moreButton.tag = indexPath.row

//        if cell.isExpand {
//            heightList[indexPath.row] = 370
//            cell.detailViewHeight.constant = 100
//            cell.detailView.isHidden = false
//        } else {
            heightList[indexPath.row] = 265
            cell.detailViewHeight.constant = 0
            cell.detailView.isHidden = true
//        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightList[indexPath.row]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = DietViewController.dietList[indexPath.row]
        selectedIndex = indexPath
        let foodRecepieVC = FoodRecipeViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        foodRecepieVC.foodID = cellData.id
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: foodRecepieVC)
    }
}
