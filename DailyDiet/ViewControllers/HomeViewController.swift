//
//  HomeViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit

enum DietType: String {
    case vegan, noGluten, olive, paleo, sandwich, broccoli
}

class HomeViewController: BaseViewController {
    
    @IBOutlet var mealsCountDropdown: iOSDropDown!
    @IBOutlet var calorieAmountLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var selectedItem: IndexPath!
    var selectedDietType: DietType!
    var mealsCount: Int = 1
    
    var dietTypeList: [String] = [
        DietType.sandwich.rawValue,
        DietType.paleo.rawValue,
        DietType.broccoli.rawValue,
        DietType.vegan.rawValue,
        DietType.noGluten.rawValue,
        DietType.olive.rawValue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func configureViews() {
        setupDropDown()
    }
    
    func setupDropDown(){
        Log.i()
        mealsCountDropdown.borderStyle = .roundedRect
        mealsCountDropdown.backgroundColor = .white
        mealsCountDropdown.optionArray = ["1 meals", "2 meals", "3 meals"]
        mealsCountDropdown.textAlignment = .left
        mealsCountDropdown.isSearchEnable = false
        mealsCountDropdown.selectedIndex = 0
        mealsCount = Int(String("1 meals".split(separator: " ")[0]))!
        
        mealsCountDropdown.didSelect { (selectedText, index, id) in
            self.mealsCount = Int(String(selectedText.split(separator: " ")[0]))!
        }
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


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dietTypeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = dietTypeList[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DietTypeCollectionViewCell", for: indexPath) as? DietTypeCollectionViewCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        
        cell.iconImageView.image = UIImage(named: cellData)
        cell.iconImageView.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = dietTypeList[indexPath.row]
        if selectedItem != nil {
            let cell = collectionView.cellForItem(at: selectedItem) as! DietTypeCollectionViewCell
            cell.iconImageView.backgroundColor = .white
        }
        selectedItem = indexPath
        selectedDietType = DietType(rawValue: cellData)
        let cell = collectionView.cellForItem(at: indexPath) as! DietTypeCollectionViewCell
        cell.iconImageView.backgroundColor = .brandGreen
        
    }
}



