//
//  DashboardViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring

enum PresentView{
    case SignIn, SignUp, ChangePassword
}

protocol LoginStatusDelegate {
    func updateLoginStatus()
}

protocol PresentViewDelegate {
    func showView(viewType: PresentView)
}

class DashboardViewController: BaseViewController {
    
    @IBOutlet var modifyPasswordButton: DesignableButton!
    @IBOutlet var signInButton: DesignableButton!
    
    static var presentDelegate: PresentViewDelegate!
    static var loginDelegate: LoginStatusDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        DashboardViewController.presentDelegate = self
        DashboardViewController.loginDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
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
        StoringData.token = ""
        StoringData.refreshToken = ""
        TabBarViewController.changeTabBarDelegate.changeTabBarIndex(index: 0)
    }
    
    func doSignInAction(){
        Log.i()
        performSegue(withIdentifier: "SignInSegue", sender: self)
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        if StoringData.isLoggedIn {
            doSignOutAction()
        } else {
            doSignInAction()
        }
    }
}

extension DashboardViewController: LoginStatusDelegate {
    func updateLoginStatus() {
        configureViews()
    }
}

extension DashboardViewController: PresentViewDelegate {
    func showView(viewType: PresentView) {
        switch viewType {
        case .ChangePassword:
            let changePasswordVC = ChangePasswordViewController.instantiateFromStoryboardName(storyboardName: .UserAction)
            changePasswordVC.modalPresentationStyle = .fullScreen
            SegueHelper.presentViewController(sourceViewController: self, destinationViewController: changePasswordVC)
        case .SignIn:
            performSegue(withIdentifier: "SignInSegue", sender: self)
        case .SignUp:
            performSegue(withIdentifier: "SignUpSegue", sender: self)
        }
    }
}
