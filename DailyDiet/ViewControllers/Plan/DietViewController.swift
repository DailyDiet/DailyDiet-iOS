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
    
    static var dietList: [DietClass] = []
    var heightList: [CGFloat] = []
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow(at: selectedIndex, animated: false)
        for _ in 0..<DietViewController.dietList.count {
            heightList.append(265)
        }
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
        if DietViewController.dietList.count == 0 {
            tableView.tableHeaderView?.isHidden = false
        } else {
            tableView.tableHeaderView?.isHidden = true
        }
        return DietViewController.dietList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietTableViewCell", for: indexPath) as! DietTableViewCell
        let cellData = DietViewController.dietList[indexPath.row]
        cell.moreButton.setImage(UIImage.fontAwesomeIcon(name: .infoCircle, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)), for: .normal)
        cell.nameLabel.text = cellData.title
        cell.foodImageView.sd_setImage(with: URL(string: (cellData.image ?? cellData.thumbnail)!))
        
        cell.calorieLabel.text = "\(cellData.nutrition.calories) Calories"
        cell.fatLabel.text = "\(cellData.nutrition.fat)"
        cell.fiberLabel.text = "\(cellData.nutrition.fiber)"
        cell.proteinLabel.text = "\(cellData.nutrition.protein)"
        
        cell.moreButton.tag = indexPath.row
        
        if cell.isExpand {
            heightList[indexPath.row] = 370
            cell.detailViewHeight.constant = 100
            cell.detailView.isHidden = false
        } else {
            heightList[indexPath.row] = 265
            cell.detailViewHeight.constant = 0
            cell.detailView.isHidden = true
        }
        
        cell.layoutIfNeeded()
        
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
