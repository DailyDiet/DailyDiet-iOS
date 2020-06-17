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
    
    @IBOutlet weak var notSureButton: UIButton!
    @IBOutlet var mealsCountDropdown: iOSDropDown!
    @IBOutlet var calorieAmountLabel: UILabel!
    @IBOutlet var generateButton: DesignableButton!
    @IBOutlet var calorieStepper: UIStepper!
    
    static var delegate: CalorieDelegate!
    var mealsCount: Int = 1
    
    var APIDisposableDiet: Disposable!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeViewController.delegate = self
        
    }
    
    
    
    override func configureViews() {
        setupDropDown()
        generateButton.backgroundColor = .brandOrange
        
        notSureButton.setImage(UIImage.fontAwesomeIcon(name: .calculator, style: .solid, textColor: .brandOrange, size: CGSize(width: 15, height: 15)), for: .normal)
        notSureButton.setTitleColor(.brandOrange, for: .normal)
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
        SegueHelper.presentViewController(sourceViewController: self, destinationViewController: BMIVC)
    }
    
    @IBAction func calorieStepperValueChanged(_ sender: UIStepper) {
        calorieAmountLabel.text = String(Int(sender.value).formattedWithSeparator)
    }
    
    @IBAction func generateButtonDidTap(_ sender: Any) {
        generateButton.isEnabled = false
        generateButton.backgroundColor = .darkGray
        let calorie = (calorieAmountLabel.text ?? "100").replacingOccurrences(of: ",", with: "")
        
        API.getDiet(mealsCount: (mealsCountDropdown.selectedIndex ?? 0) + 1, calorie: Int(calorie)!) { (dietList) in
            print("Result => \(dietList)")
            DietViewController.dietList = dietList
            TabBarViewController.changeTabBarDelegate.changeTabBarIndex(index: 0)
            self.generateButton.isEnabled = true
            self.generateButton.backgroundColor = .brandOrange
        }
//        self.generateButton.isEnabled = true
//        self.generateButton.backgroundColor = .brandOrange
        //        APIDisposableDiet?.dispose()
        //        APIDisposableDiet = nil
        //        APIDisposableDiet = API.getDiet(mealsCount: (mealsCountDropdown.selectedIndex ?? 0) + 1, calorie: Int(calorie)!)
        //            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        //            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        //            .subscribe(onNext: { (response) in
        //                Log.i("getDiet => onNext => \(response)")
        //                DispatchQueue.main.async {
        //                    self.generateButton.isEnabled = true
        //                    self.generateButton.backgroundColor = .brandGreen
        //
        //
        //
        //                    var lst: [DietClass] = []
        //                    for i in 0..<response.diet.count {
        //                        Log.i("\(response.diet[i])   \(type(of: response.diet[i]))")
        //                        response.diet[i]
        //                    }
        //
        //
        
        //                }
        //
        //            }, onError: { (error) in
        //                Log.e("getDiet => onError => \(error) => \((error as NSError).domain)")
        //                let customError = (error as NSError)
        //                DispatchQueue.main.async {
        //                    self.generateButton.isEnabled = true
        //                    self.generateButton.backgroundColor = .brandGreen
        //                }
        //                DialogueHelper.showStatusBarErrorMessage(message: customError.userInfo["error"] as? String ?? "Faiiled to load diet")
        //
        //            })
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
