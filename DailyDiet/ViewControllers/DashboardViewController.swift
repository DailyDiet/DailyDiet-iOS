//
//  DashboardViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring

class DashboardViewController: BaseViewController {
    
    @IBOutlet var modifyPasswordButton: DesignableButton!
    @IBOutlet var signInButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    override func configureViews() {
        if StoringData.isLoggedIn {
            modifyPasswordButton.isHidden = false
            signInButton.setTitle("Sign out", for: .normal)
        } else {
            modifyPasswordButton.isHidden = true
            signInButton.setTitle("Sign in", for: .normal)
        }
    }
    
}

extension DashboardViewController {
    
    func doSignOutAction(){
        Log.i()
        StoringData.isLoggedIn = false
        StoringData.password = ""
        StoringData.email = ""
    }
    
    func doSignInAction(){
        Log.i()
        
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        if StoringData.isLoggedIn {
            
        } else {
            
        }
    }
}
