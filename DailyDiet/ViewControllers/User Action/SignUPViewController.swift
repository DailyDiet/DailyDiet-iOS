//
//  SignUPViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import RxSwift
import Spring

class SignUPViewController: BaseViewController {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var panToClose: InteractionPanToClose!
    
    @IBOutlet var emaiImageView: UIImageView!
    @IBOutlet var usernameImageView: UIImageView!


    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var signUpButton: DesignableButton!
    
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
        usernameImageView.image = UIImage.fontAwesomeIcon(name: .userPlus, style: .solid, textColor: .black, size: CGSize(width: 40, height: 40))
    }
    

}

//MARK: - Actions
extension SignUPViewController {
    func doSignInAction(){
        Log.i()
        panToClose.animateDialogeDisappear {
            DashboardViewController.presentDelegate.showView(viewType: .SignIn)
        }
    }
    
    func doSignUpAction(){
        Log.i()
        
    }
    
    @IBAction func signUpButtonDidTap(_ sender: Any) {
        doSignUpAction()
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        doSignInAction()
    }
}

//MARK: - TextField Delegate
extension SignUPViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        isFieldsFilled = (emailTextField.text != "") && (passwordTextField.text != "") && (usernameTextField.text != "") && (confirmPasswordTextField.text != "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            confirmPasswordTextField.resignFirstResponder()
            doSignUpAction()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

