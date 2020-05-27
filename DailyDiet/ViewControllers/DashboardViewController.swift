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
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func modifyPasswordButtonDidTap(_ sender: Any) {
        
    }
}
