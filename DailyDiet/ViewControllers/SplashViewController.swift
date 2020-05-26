//
//  SplashViewController.swift
//  DailyDiet
//
//  Created by ali on 5/26/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import SwiftyTimer

class SplashViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.after(4.second) {
            DispatchQueue.main.async {
                self.navigationController?.viewControllers = [TabBarViewController.instantiateFromStoryboardName(storyboardName: .Home)]
            }
        }
    }
    
    
}
