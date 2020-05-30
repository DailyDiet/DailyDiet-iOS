//
//  DietInfoViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import RxSwift
import Parchment
import SwiftyJSON

class FoodRecipeViewController: BaseViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cookTimeLabel: UILabel!
    @IBOutlet var preparationTimeLabel: UILabel!
    @IBOutlet var tabBarView: UIView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var foodImageView: UIImageView!
    
    var titles: [String] = []
    var viewControllers: [UIViewController] = []
    
    var foodRecipe: Recipe!
    var foodID: Int!
    var APIDisposabelRecipe: Disposable!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = false
        APIDisposabelRecipe?.dispose()
        APIDisposabelRecipe = nil
        APIDisposabelRecipe = API.getRecipe(foodID: foodID)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("signIn => onNext => \(response)")
                DispatchQueue.main.async {
                    self.loadingView.isHidden  = true
                    self.foodRecipe = response
                    
                    self.nameLabel.text = self.foodRecipe.foodName
                    self.preparationTimeLabel.text = "\(self.foodRecipe.cookTime) mins to cook"
                    self.preparationTimeLabel.text = "\(self.foodRecipe.prepTime) mins to prep"
                    self.foodImageView.sd_setImage(with: URL(string: self.foodRecipe.primaryThumbnail))
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("signIn => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                DispatchQueue.main.async {
                    
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed to load recipe")
                    SegueHelper.popViewController(viewController: self)
                }
                
                switch customError.code {
                case 403:
                    if let errorMessage = customError.userInfo["error"] as? String {
                        if errorMessage == "Email or Password does not match." {
                            DialogueHelper.showStatusBarErrorMessage(message: errorMessage)
                        }
                    }
                case 400:
                    if let errorJson = customError.userInfo["errors"] as? JSON {
                        let errorMessage = errorJson.dictionary?["email"]?.string
                        DialogueHelper.showStatusBarErrorMessage(message: errorMessage ?? "Error")
                    }
                default:
                    DialogueHelper.showStatusBarErrorMessage(message: "Error")
                }
            })
        
    }
    
    func makeArrays() -> ([String], [UIViewController]){
        Log.i()
        var titlesArray: [String] = []
        var viewControllerArray: [UIViewController] = []
        
        let directionVC = DirectionsViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        directionVC.directionList = foodRecipe.directions
        titlesArray.append("Directions")
        viewControllerArray.append(directionVC)
        
        let ingredientsVC = IngredientsViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        titlesArray.append("Ingredients")
        ingredientsVC.ingredientList = foodRecipe.ingredients
        viewControllerArray.append(ingredientsVC)
        
        return (titlesArray, viewControllerArray)
    }
    
    func setupTabBar(){
        Log.i()
        (titles, viewControllers) = makeArrays()
        let pagingViewController = MainPagingViewController(viewControllers: viewControllers)
        pagingViewController.configure(backgroundColor: .gray85, indicatorColor: .brandGreen)
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        pagingViewController.menuItemSpacing = 15
        pagingViewController.setItemSize(width: screenWidth, n: viewControllers.count)
        addChild(pagingViewController)
        tabBarView.addSubview(pagingViewController.view)
        tabBarView.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.select(index: 1, animated: true)
    }

    @IBAction func closeButtonDidTap(_ sender: Any) {
        SegueHelper.popViewController(viewController: self)
    }
}

extension FoodRecipeViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return viewControllers.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
}


