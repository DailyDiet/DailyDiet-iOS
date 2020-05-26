//
//  TabBarViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//
import BATabBarController
import UIKit
import FontAwesome_swift

class TabBarViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
    }
    
    func setupTabbar(){
        Log.i()
        let vc2 = HomeViewController.instantiateFromStoryboardName(storyboardName: .Home)
        let vc1 = SearchViewController.instantiateFromStoryboardName(storyboardName: .Home)
        let vc3 = DashboardViewController.instantiateFromStoryboardName(storyboardName: .Home)
        
        let option1 = NSMutableAttributedString(string: "Search")
        let option2 = NSMutableAttributedString(string: "Home")
        let option3 = NSMutableAttributedString(string: "Dashboard")
        
        option1.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: option1.length))
        option2.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: option2.length))
        option3.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: option3.length))
        
        let tabBarItem  = BATabBarItem(image: UIImage.fontAwesomeIcon(name: .search, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25)), selectedImage: UIImage.fontAwesomeIcon(name: .search, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)), title: option1)
        let tabBarItem2 = BATabBarItem(image: UIImage(named: "logo")!, selectedImage: UIImage(named: "logo")!, title: option2)
        let tabBarItem3  = BATabBarItem(image: UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25)), selectedImage: UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: .black, size: CGSize(width: 25, height: 25)), title: option3)

        
        
        let baTabBarController = BATabBarController()
        baTabBarController.viewControllers = [vc1, vc2, vc3]
        baTabBarController.tabBarItems = [tabBarItem, tabBarItem2, tabBarItem3]
        baTabBarController.tabBarBackgroundColor = .gray85
        baTabBarController.tabBarItemStrokeColor = .brandGreen
        baTabBarController.hidesBottomBarWhenPushed = true
        baTabBarController.delegate = self
        self.view.addSubview(baTabBarController.view)
    }
    
    
}


extension TabBarViewController: BATabBarControllerDelegate {
    func tabBarController(_ tabBarController: BATabBarController, didSelect: UIViewController) {
        
    }
    
}

