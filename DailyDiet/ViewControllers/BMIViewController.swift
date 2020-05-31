//
//  BMIViewController.swift
//  DailyDiet
//
//  Created by ali on 5/30/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import RxSwift
import Spring

enum Gender: String {
    case male, female
}

enum WeightGoal: String {
    case LoseWeight = "lose_weight"
    case Maintain = "maintain"
    case BuildMuscle = "build_muscle"
}

enum ActivityLevel: String {
    case sedentary, lightly, moderately, very, extra
}

class BMIViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet var dismissView: UIView!
    @IBOutlet var generateButton: DesignableButton!
    @IBOutlet var activityLabelDropDown: iOSDropDown!
    @IBOutlet var dietTypeLabel: UILabel!
    @IBOutlet var weightSegmentedControl: UISegmentedControl!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    var gender: Gender? = nil
    var weightGoal: WeightGoal = .LoseWeight
    var activityLevel: ActivityLevel = .sedentary
    
    var APIDisposableCalorie: Disposable!
    var APIDisposableBMI: Disposable!

    var dietType: String!
    var height: Int = 0
    var weight: Int = 0
    var age: Int = 0
    
    var isFieldsFilled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        tap.delegate = self
        self.dismissView.addGestureRecognizer(tap)
        
        
        weightTextField.delegate = self
        ageTextField.delegate = self
        heightTextField.delegate = self
    }
    
    func configureDropDown(){
        activityLabelDropDown.borderStyle = .roundedRect
        activityLabelDropDown.backgroundColor = .white
        activityLabelDropDown.optionArray = [
            "Little or no exercise",
            "Sports 1-3 days/week",
            "Sports 3-5 days/week",
            "Sports 6-7 days a week",
            "Sports & Physical job or 2x training"
            ]
        activityLabelDropDown.textAlignment = .left
        activityLabelDropDown.isSearchEnable = false
        activityLabelDropDown.selectedIndex = 0
        activityLabelDropDown.text = "Little or no exercise"
        activityLevel = .sedentary
        activityLabelDropDown.didSelect { (selectedText, index, id) in
            switch index {
            case 0:
                self.activityLevel = .sedentary
            case 1:
                self.activityLevel = .lightly
            case 2:
                self.activityLevel = .sedentary
            case 3:
                self.activityLevel = .sedentary
            case 4:
                self.activityLevel = .sedentary
            default:
                break
            }
        }
        
        activityLabelDropDown.listDidAppear {
            for textField in [self.ageTextField, self.heightTextField, self.weightTextField] {
                if textField!.isFirstResponder {
                    textField?.resignFirstResponder()
                }
            }
        }
    }
    
    func configureSegmentedControls(){
        Log.i()
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brandBlue]
        
        UISegmentedControl.appearance().setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    override func configureViews() {
        dietTypeLabel.text = dietType.uppercased()
        configureDropDown()
        configureSegmentedControls()
        
        ageTextField.keyboardType = .asciiCapableNumberPad
        weightTextField.keyboardType = .asciiCapableNumberPad
        heightTextField.keyboardType = .asciiCapableNumberPad
    }
    
    func showFillTheFieldsError(){
        Log.i()
        DialogueHelper.showStatusBarErrorMessage(message: "Fill the fields")
    }
    
    func doGenerateAction(){
        isFieldsFilled = (heightTextField.text != "") && (weightTextField.text != "") && (ageTextField.text != "")
        if !isFieldsFilled {
            showFillTheFieldsError()
            return
        }
        
        ageTextField.endEditing(true)
        weightTextField.endEditing(true)
        heightTextField.endEditing(true)
        
        if gender != nil  {
            generateButton.backgroundColor = .darkGray
            generateButton.isEnabled = false
            APIDisposableBMI?.dispose()
            APIDisposableBMI = nil
            APIDisposableBMI = API.bmi(weight: weight, height: height)
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { (response) in
                    Log.i("bmi => onNext => \(response)")
                        
                        TabBarViewController.changeTabBarDelegate.setBMI(bmi: response.bmiValue, bmiStatus: response.bmiStatus)
                        
                    self.APIDisposableCalorie?.dispose()
                    self.APIDisposableCalorie = nil
                    self.APIDisposableCalorie = API.calculateCalorie(goal: self.weightGoal.rawValue, gender: self.gender!.rawValue, height: self.height, weight: self.weight, age: self.age, activity: self.activityLevel.rawValue)
                            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                            .subscribe(onNext: { (response) in
                                Log.i("calculateCalorie => onNext => \(response)")
                                DispatchQueue.main.async {
                                    self.generateButton.isEnabled = true
                                    self.generateButton.backgroundColor = .brandGreen
                                    
                                    self.dismiss(animated: true) {
                                    HomeViewController.delegate.setCalorie(calorie: response.calorie)
                                    }
                                    
                                    
                                }
                                
                            }, onError: { (error) in
                                Log.e("calculateCalorie => onError => \(error) => \((error as NSError).domain)")
                                let customError = (error as NSError)
                                DispatchQueue.main.async {
                                    self.generateButton.isEnabled = true
                                    self.generateButton.backgroundColor = .brandGreen
                                }
                                
                                if let errorList = (customError.userInfo["errors"] as? [String : [String]]) {
                                if let activityError = errorList["activity"]?[0] {
                                    DialogueHelper.showStatusBarErrorMessage(message: activityError)
                                }else if let ageError = errorList["age"]?[0] {
                                    DialogueHelper.showStatusBarErrorMessage(message: ageError)
                                }else if let genderError = errorList["gender"]?[0] {
                                    DialogueHelper.showStatusBarErrorMessage(message: genderError)
                                }else if let goalError = errorList["goal"]?[0] {
                                    DialogueHelper.showStatusBarErrorMessage(message: goalError)
                                }else if let heightError = errorList["height"]?[0] {
                                    DialogueHelper.showStatusBarErrorMessage(message: heightError)
                                }else if let weightError = errorList["weight"]?[0] {
                                    DialogueHelper.showStatusBarErrorMessage(message: weightError)
                                }
                                }
                            })
                }, onError: { (error) in
                    Log.e("bmi => onError => \(error) => \((error as NSError).domain)")
                    let customError = (error as NSError)
                    DispatchQueue.main.async {
                        self.generateButton.isEnabled = true
                        self.generateButton.backgroundColor = .brandGreen
                    }
                    
                    if let heightError = (customError.userInfo["errors"] as? [String : [String]])?["height"]?[0] {
                        DialogueHelper.showStatusBarErrorMessage(message: heightError)
                    }else if let weightError = (customError.userInfo["errors"] as? [String : [String]])?["weight"]?[0] {
                        DialogueHelper.showStatusBarErrorMessage(message: weightError)
                    }
                    
                })
        } else {
            DialogueHelper.showStatusBarErrorMessage(message: "Select Gender")
        }
    }
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func weightSegmentedDidChangeValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            weightGoal = .LoseWeight
        case 1:
            weightGoal = .Maintain
        case 2:
            weightGoal = .BuildMuscle
        default:
            break
        }
    }
    
    @IBAction func genderSegmentedDidChangeValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gender = .male
        case 1:
            gender = .female
        default:
            break
        }
    }
    
    @IBAction func generateButtonDidTap(_ sender: Any) {
        doGenerateAction()
    }
}

extension BMIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case heightTextField:
            heightTextField.resignFirstResponder()
            weightTextField.becomeFirstResponder()
        case weightTextField:
            weightTextField.resignFirstResponder()
            ageTextField.becomeFirstResponder()
        case ageTextField:
            ageTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case heightTextField:
            height = Int(heightTextField.text ?? "0") ?? 0
        case weightTextField:
            weight = Int(weightTextField.text ?? "0") ?? 0
        case ageTextField:
            age = Int(ageTextField.text ?? "0") ?? 0
        default:
            textField.resignFirstResponder()
        }
        isFieldsFilled = (heightTextField.text != "") && (weightTextField.text != "") && (ageTextField.text != "")
    }
}
