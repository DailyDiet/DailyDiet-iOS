//
//  LoginViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import RxSwift
import Spring
import SwiftyJSON
import FontAwesome_swift

class LoginViewController: BaseViewController {
    
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var emaiImageView: UIImageView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var signInButton: DesignableButton!
    @IBOutlet var panToClose: InteractionPanToClose!
    
    var APIDisposabelSignIn: Disposable!
    var isFieldsFilled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panToClose.setGestureRecognizer()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func configureViews() {
        iconImageView.image = UIImage.fontAwesomeIcon(name: .signInAlt, style: .solid, textColor: .gray, size: iconImageView.frame.size)
        emaiImageView.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .black, size: CGSize(width: 40, height: 40))
    }
    
}

//MARK: - Configure Views
extension LoginViewController {
    func showFillTheFieldsError(){
        Log.i()
        DialogueHelper.showStatusBarErrorMessage(message: "Fill the fields")
    }
}

//MARK: - Actions
extension LoginViewController {
    func doSignInAction(){
        Log.i()
        isFieldsFilled = (emailTextField.text != "") && (passwordTextField.text != "")
        
        if isFieldsFilled {
        signInButton.isEnabled = false
            signInButton.backgroundColor = .darkGray
        APIDisposabelSignIn?.dispose()
        APIDisposabelSignIn = nil
        APIDisposabelSignIn = API.signIn(email: emailTextField.text!, password: passwordTextField.text!)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("signIn => onNext => \(response)")
                DispatchQueue.main.async {
                    self.signInButton.isEnabled = true
                    self.signInButton.backgroundColor = .brandBlue
                    StoringData.token = response.accessToken
                    StoringData.refreshToken = response.refreshToken
                    StoringData.isLoggedIn = true
                    self.panToClose.animateDialogeDisappear() {
                        DashboardViewController.loginDelegate.updateLoginStatus()
                    }
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("signIn => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                DispatchQueue.main.async {
                    self.signInButton.isEnabled = true
                    self.signInButton.backgroundColor = .brandBlue
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed to sign in")
                }
                
                switch customError.code {
                case 403:
                    if let errorMessage = customError.userInfo["error"] as? String {
                        if errorMessage == "Email or Password does not match." {
                            DialogueHelper.showStatusBarErrorMessage(message: errorMessage)
                        }
                    }
                case 400:
                    if let errorJson = customError.userInfo["errors"] as? JSON {
                        let errorMessage = errorJson.dictionary?["email"]?.string
                        DialogueHelper.showStatusBarErrorMessage(message: errorMessage ?? "Error")
                    }
                default:
                    DialogueHelper.showStatusBarErrorMessage(message: "Error")
                }
            })
        }
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        doSignInAction()
    }
    
    
    @IBAction func signUpButtonDidTap(_ sender: Any) {
        panToClose.animateDialogeDisappear {
            DashboardViewController.presentDelegate.showView(viewType: .SignUp)
        }
    }
}


//MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        isFieldsFilled = (emailTextField.text != "") && (passwordTextField.text != "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            doSignInAction()
        }
        return true
    }
}
