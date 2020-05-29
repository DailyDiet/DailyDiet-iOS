//
//  PlanResultViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring

class DietViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    
    var dietList: [DietElement] = []
    var heightList: [CGFloat] = []
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<dietList.count {
            heightList[i] = 265
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow(at: selectedIndex, animated: false)
    }
    
    
    @IBAction func moreButtonDidTap(_ sender: UIButton) {
        (tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? DietTableViewCell)?.isExpand = true
        heightList[sender.tag] = 370
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    

}


extension DietViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dietList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietTableViewCell", for: indexPath) as! DietTableViewCell
        let cellData = dietList[indexPath.row]
//        let dataJSON =
        
        if cell.isExpand {
            heightList[indexPath.row] = 370
        } else {
            heightList[indexPath.row] = 265
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightList[indexPath.row]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = dietList[indexPath.row]
        selectedIndex = indexPath
        let foodRecepieVC = 
        SegueHelper
    }
}
