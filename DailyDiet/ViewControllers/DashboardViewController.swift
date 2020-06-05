//
//  DashboardViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import RxSwift

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
    
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet var modifyPasswordButton: DesignableButton!
    @IBOutlet var signInButton: DesignableButton!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    static var presentDelegate: PresentViewDelegate!
    static var loginDelegate: LoginStatusDelegate!
    var APIDisposableUserInfo: Disposable!
    var APIDisposableSignOut: Disposable!
    
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
            
            self.APIDisposableUserInfo?.dispose()
            self.APIDisposableUserInfo = nil
            self.APIDisposableUserInfo = API.userInfo()
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { (response) in
                    Log.i("userInfo => onNext => \(response)")
                    DispatchQueue.main.async {
                        if response.confirmed == "True" {
                            ValueKeeper.User = UserInfo(confirmed: response.confirmed, email: response.email, fullName: response.fullName)
                            
                            self.modifyPasswordButton.isHidden = false
                            self.signInButton.setTitle("Sign out", for: .normal)
                            self.profileStackView.isHidden = false
                            self.fullNameLabel.text = response.fullName
                            self.emailLabel.text = response.email
                            
                        } else if response.confirmed == "False"{
                            StoringData.token = ""
                            StoringData.refreshToken = ""
                            StoringData.isLoggedIn = false
                            DialogueHelper.showStatusBarErrorMessage(message: "Confirm your account with the link we sent to your email.")
                            
                            
                        }
                    }
                    
                    //Login OK
                }, onError: { (error) in
                    Log.e("userInfo => onError => \(error) => \((error as NSError).domain)")
                    let customError = (error as NSError)
                    print(customError.userInfo)
                    DispatchQueue.main.async {
                        self.profileStackView.isHidden = true
                        self.modifyPasswordButton.isHidden = true
                        self.signInButton.setTitle("Sign in", for: .normal)
                        StoringData.token = ""
                        StoringData.refreshToken = ""
                        StoringData.isLoggedIn = false
                        DialogueHelper.showStatusBarErrorMessage(message: "Failed to sign in")
                    }
                })
        } else {
            profileStackView.isHidden = true
            modifyPasswordButton.isHidden = true
            signInButton.setTitle("Sign in", for: .normal)
        }
    }
    
}

extension DashboardViewController {
    
    func doSignOutAction(){
        Log.i()
        self.signInButton.isEnabled = false
        self.signInButton.borderColor = .darkGray
        self.signInButton.setTitleColor(.darkGray, for: .normal)
        
        APIDisposableSignOut?.dispose()
        APIDisposableSignOut = nil
        APIDisposableSignOut = API.signOut()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("signOut => onNext => \(response)")
                DispatchQueue.main.async {
                    self.signInButton.isEnabled = true
                    self.signInButton.borderColor = .brandBlue
                    self.signInButton.setTitleColor(.brandBlue, for: .normal)
                    StoringData.isLoggedIn = false
                    StoringData.password = ""
                    StoringData.email = ""
                    StoringData.token = ""
                    StoringData.refreshToken = ""
                    TabBarViewController.changeTabBarDelegate.changeTabBarIndex(index: 1)
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("userInfo => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                print(customError.userInfo)
                DispatchQueue.main.async {
                    self.signInButton.isEnabled = true
                    self.signInButton.borderColor = .brandBlue
                    self.signInButton.backgroundColor = .white
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed to sign out")
                }
            })
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
