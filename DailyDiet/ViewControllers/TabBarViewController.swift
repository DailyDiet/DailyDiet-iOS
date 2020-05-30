//
//  TabBarViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//
import Parchment
import UIKit


protocol ChangeTabBarDelegate {
    func changeTabBarIndex(index: Int)
    func setBMI(bmi: Double, bmiStatus: String)
    func updateTabBar()
}


class TabBarViewController: BaseViewController {
    
    @IBOutlet var tabBarView: UIView!
    @IBOutlet var bmiLabel: UILabel!
    
    static var changeTabBarDelegate: ChangeTabBarDelegate!
    var pagingViewController: MainPagingViewController!
    var titles: [String] = []
    var viewControllers: [UIViewController] = []
    
    static var isPlanGenerated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        TabBarViewController.changeTabBarDelegate = self
    }
    
    override func configureViews() {
        bmiLabel.isHidden = true
    }
    
    func makeArrays() -> ([String], [UIViewController]){
        Log.i()
        var titlesArray: [String] = []
        var viewControllerArray: [UIViewController] = []
        
        let planResultVC = DietViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        titlesArray.append("Plan")
        viewControllerArray.append(planResultVC)
        
        let homeVC = HomeViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        titlesArray.append("Home")
        viewControllerArray.append(homeVC)
        
        let dashboardVC = DashboardViewController.instantiateFromStoryboardName(storyboardName: .UserAction)
        titlesArray.append("Dashboard")
        viewControllerArray.append(dashboardVC)
        
        return (titlesArray, viewControllerArray)
    }
    
    func setupTabBar(){
        Log.i()
        (titles, viewControllers) = makeArrays()
        pagingViewController = MainPagingViewController(viewControllers: viewControllers)
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
    
    @IBAction func searchBarDidTap(_ sender: Any) {
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: SearchViewController.instantiateFromStoryboardName(storyboardName: .Home))
    }
    
}


extension TabBarViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
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

extension TabBarViewController: ChangeTabBarDelegate {
    
    func setBMI(bmi: Double, bmiStatus: String) {
        bmiLabel.isHidden = false
        bmiLabel.text = "BMI: \(bmi) (\(bmiStatus))"
    }
    
    func changeTabBarIndex(index: Int) {
        pagingViewController.select(index: index, animated: true)
    }
    
    func updateTabBar() {
        setupTabBar()
        
    }
}
