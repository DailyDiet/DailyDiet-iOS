//
//  DirectionsViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit

class DirectionsViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var directionList: [Direction] = []
    var heightList: [CGFloat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<directionList.count {
            heightList.append(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DirectionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionTableViewCell", for: indexPath) as! DirectionTableViewCell
        let cellData = directionList[indexPath.row]
        cell.stepLabel.text = "Step \(indexPath.row + 1)"
        cell.detailLabel.text = cellData.text

        cell.detailLabel.numberOfLines = 0
        let maximumLabelSize: CGSize = CGSize(width: 280, height: 9999)
        let expectedLabelSize: CGSize = cell.detailLabel.sizeThatFits(maximumLabelSize)
        var newFrame: CGRect = cell.detailLabel.frame
        newFrame.size.height = expectedLabelSize.height
        cell.detailLabel.frame = newFrame

        cell.containerViewHeight.constant = newFrame.height + 20
        heightList[indexPath.row] = cell.detailLabel.frame.height + 40
            
        tableView.beginUpdates()
        tableView.endUpdates()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightList[indexPath.row]
    }
    
    
}
