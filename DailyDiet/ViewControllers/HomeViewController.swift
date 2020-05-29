//
//  HomeViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet var calorieAmountLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func notSureButtonDidTap(_ sender: Any) {
        //        SegueHelper.presentViewController(sourceViewController: self, destinationViewController: )
    }
    
    @IBAction func calorieStepperValueChanged(_ sender: UIStepper) {
        calorieAmountLabel.text = String(Int(sender.value).formattedWithSeparator)
    }
    
    @IBAction func generateButtonDidTap(_ sender: Any) {
        
    }
}




