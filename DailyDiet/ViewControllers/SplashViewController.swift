//
//  SplashViewController.swift
//  DailyDiet
//
//  Created by ali on 5/26/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyTimer

class SplashViewController: BaseViewController {
    
    
    var APIDisposableRefreshToken: Disposable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        APIDisposableRefreshToken?.dispose()
        APIDisposableRefreshToken = nil
        APIDisposableRefreshToken = API.refreshToken()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("refreshToken => onNext => \(response)")
                DispatchQueue.main.async {
                    StoringData.token = response.accessToken
                    StoringData.isLoggedIn = true
                    
                    self.navigationController?.viewControllers = [TabBarViewController.instantiateFromStoryboardName(storyboardName: .Home)]
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("refreshToken => onError => \(error) => \((error as NSError).domain)")
                DispatchQueue.main.async {
                    StoringData.token = ""
                    StoringData.refreshToken = ""
                    StoringData.isLoggedIn = false

                    self.navigationController?.viewControllers = [TabBarViewController.instantiateFromStoryboardName(storyboardName: .Home)]
                }

            })
    }
    
    
}
