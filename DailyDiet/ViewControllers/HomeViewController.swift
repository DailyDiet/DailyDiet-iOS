//
//  HomeViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import RxSwift
import SwiftyJSON

enum DietType: String {
    case vegan = "Vegan"
    case noGluten = "Ketogenic"
    case olive = "Mediterranean"
    case paleo
    case sandwich = "Anything"
    case broccoli = "Vegetarian"
}

protocol CalorieDelegate {
    func setCalorie(calorie: Int)
}

class HomeViewController: BaseViewController {
    
    @IBOutlet var mealsCountDropdown: iOSDropDown!
    @IBOutlet var calorieAmountLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var generateButton: DesignableButton!
    @IBOutlet var calorieStepper: UIStepper!

    static var delegate: CalorieDelegate!
    var selectedItem: IndexPath!
    var selectedDietType: DietType? = nil
    var mealsCount: Int = 1
    
    var cellWidth: [CGFloat] = []
    
    var APIDisposableDiet: Disposable!
    
    var dietTypeList: [DietType] = [
        DietType.sandwich,
        DietType.paleo,
        DietType.broccoli,
        DietType.vegan,
        DietType.noGluten,
        DietType.olive
    ]
    
    var collectionList: [String] = ["vegan", "noGluten", "olive", "paleo", "sandwich", "broccoli"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.de
        HomeViewController.delegate = self
        
        for _ in 0..<dietTypeList.count {
            cellWidth.append(100)
        }
    }
    
    
    
    override func configureViews() {
        setupDropDown()
        generateButton.backgroundColor = .brandGreen
    }
    
    func setupDropDown(){
        Log.i()
        mealsCountDropdown.borderStyle = .roundedRect
        mealsCountDropdown.backgroundColor = .white
        mealsCountDropdown.optionArray = ["1 meals", "2 meals", "3 meals"]
        mealsCountDropdown.textAlignment = .left
        mealsCountDropdown.isSearchEnable = false
        mealsCountDropdown.selectedIndex = 0
        mealsCountDropdown.text = "1 meals"
        mealsCount = Int(String("1 meals".split(separator: " ")[0]))!
        
        mealsCountDropdown.didSelect { (selectedText, index, id) in
            self.mealsCount = Int(String(selectedText.split(separator: " ")[0]))!
        }
    }
    
    @IBAction func notSureButtonDidTap(_ sender: Any) {
        let BMIVC = BMIViewController.instantiateFromStoryboardName(storyboardName: .Home)
        BMIVC.dietType = selectedDietType?.rawValue ?? "Not Selected"
        SegueHelper.presentViewController(sourceViewController: self, destinationViewController: BMIVC)
    }
    
    @IBAction func calorieStepperValueChanged(_ sender: UIStepper) {
        calorieAmountLabel.text = String(Int(sender.value).formattedWithSeparator)
    }
    
    @IBAction func generateButtonDidTap(_ sender: Any) {
        generateButton.isEnabled = false
        generateButton.backgroundColor = .darkGray
        let calorie = (calorieAmountLabel.text ?? "100").replacingOccurrences(of: ",", with: "")
        
        APIDisposableDiet?.dispose()
        APIDisposableDiet = nil
        APIDisposableDiet = API.getDiet(mealsCount: mealsCountDropdown.selectedIndex ?? 0, calorie: Int(calorie    )!)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("getDiet => onNext => \(response)")
                DispatchQueue.main.async {
                    self.generateButton.isEnabled = true
                    self.generateButton.backgroundColor = .brandGreen
                    var lst: [DietClass] = []
                    for i in 0..<response.diet.count {
//                        if let dietItem = response.diet[i].encode(to: DietClass.self as! Encoder) {
//                            lst.append(diet)
//                        }
                    }
                    
                    DietViewController.dietList = lst
                    TabBarViewController.changeTabBarDelegate.changeTabBarIndex(index: 0)
                }
                
            }, onError: { (error) in
                Log.e("getDiet => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                DispatchQueue.main.async {
                    self.generateButton.isEnabled = true
                    self.generateButton.backgroundColor = .brandGreen
                }
                DialogueHelper.showStatusBarErrorMessage(message: customError.userInfo["error"] as? String ?? "Faiiled to load diet")

            })
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dietTypeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = collectionList[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DietTypeCollectionViewCell", for: indexPath) as? DietTypeCollectionViewCell else {
            fatalError("Unable to dequeue Cell.")
        }
        
        cell.iconImageView.image = UIImage(named: cellData)
        cell.nameLabel.text = dietTypeList[indexPath.row].rawValue.uppercased()
        cell.nameLabel.sizeToFit()
        cellWidth[indexPath.row] = cell.nameLabel.frame.width + 10
        collectionView.reloadItems(at: [indexPath])
        cell.containerView.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = dietTypeList[indexPath.row]
        if selectedItem != nil {
            if let cell = collectionView.cellForItem(at: selectedItem) as? DietTypeCollectionViewCell{
            cell.containerView.backgroundColor = .white
            cell.nameLabel.textColor = .black
            }
        }
        selectedItem = indexPath
        selectedDietType = cellData
        let cell = collectionView.cellForItem(at: indexPath) as! DietTypeCollectionViewCell
        cell.containerView.backgroundColor = .brandGreen
        cell.nameLabel.textColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 90)
    }
}

extension HomeViewController: CalorieDelegate {
    func setCalorie(calorie: Int) {
        DispatchQueue.main.async {
            self.calorieAmountLabel.text = "\(calorie)"
            self.calorieStepper.value = Double(calorie)
        }
    }
}
