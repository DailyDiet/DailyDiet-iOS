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
                    self.cookTimeLabel.text = "\(self.foodRecipe.cookTime) mins to cook"
                    self.preparationTimeLabel.text = "\(self.foodRecipe.prepTime) mins to prep"
                    self.foodImageView.sd_setImage(with: URL(string: self.foodRecipe.primaryThumbnail))
                    self.setupTabBar()
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("signIn => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                DispatchQueue.main.async {
                    if let errorMessage = customError.userInfo["error"] as? String {
                        DialogueHelper.showStatusBarErrorMessage(message: errorMessage)
                    } else {
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed to load recipe")
                    }
                    SegueHelper.popViewController(viewController: self)
                    
                }
                
            })
        
    }
    
    func makeArrays() -> ([String], [UIViewController]){
        Log.i()
        var titlesArray: [String] = []
        var viewControllerArray: [UIViewController] = []
        
        let ingredientsVC = IngredientsViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        titlesArray.append("Ingredients")
        ingredientsVC.ingredientList = foodRecipe.ingredients
        viewControllerArray.append(ingredientsVC)
        
        let directionVC = DirectionsViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        directionVC.directionList = foodRecipe.directions
        titlesArray.append("Directions")
        viewControllerArray.append(directionVC)
        
        return (titlesArray, viewControllerArray)
    }
    
    func setupTabBar(){
        Log.i()
        (titles, viewControllers) = makeArrays()
        let pagingViewController = MainPagingViewController(viewControllers: viewControllers)
        pagingViewController.configure(backgroundColor: .clear, indicatorColor: .brandGreen)
        pagingViewController.dataSource = self
        pagingViewController.delegate = self
        pagingViewController.menuItemSpacing = 15
        pagingViewController.setItemSize(width: screenWidth, n: viewControllers.count)
        addChild(pagingViewController)
        tabBarView.addSubview(pagingViewController.view)
        tabBarView.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.select(index: 0, animated: true)
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


