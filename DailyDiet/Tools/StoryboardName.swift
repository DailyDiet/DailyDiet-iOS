//
//  StoryboardName.swift
//  HamrameMan
//
//  Created by negar on 99/Ordibehesht/02 AP.
//  Copyright © 1399 negar. All rights reserved.
//

import UIKit

enum StoryboardName: String {
    case Main, UserAction, Dashboard, Search


    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        Log.i()

        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID

        return self.instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }

    func initialViewController() -> UIViewController? {
        Log.i()

        return instance.instantiateInitialViewController()
    }
}
