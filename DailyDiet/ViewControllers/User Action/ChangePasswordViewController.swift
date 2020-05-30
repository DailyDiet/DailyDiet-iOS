//
//  ChangePasswordViewController.swift
//  DailyDiet
//
//  Created by ali on 5/29/20.
//  Copyright © 2020 Alireza. All rights reserved.
//
import RxSwift
import UIKit
import Spring
import SwiftyJSON

class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet var confirmNewPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var requestRecoveryButton: DesignableButton!
    @IBOutlet var panToClose: InteractionPanToClose!
    
    var APIDisposableChangePassword: Disposable!
    var passwordsMatches: Bool = false
    var allFieldsFilled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panToClose.setGestureRecognizer()
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmNewPasswordTextField.delegate = self
    }
    
    
    
    func doRequestRecoverAction(){
        Log.i()
        
        if confirmNewPasswordTextField.text != newPasswordTextField.text {
            showPasswordNotMatchError()
            passwordsMatches = false
        } else {
            passwordsMatches = true
        }
        allFieldsFilled = (oldPasswordTextField.text != "") && (newPasswordTextField.text != "") && (confirmNewPasswordTextField.text != "")
        
        if passwordsMatches && allFieldsFilled {
            requestRecoveryButton.isEnabled = false
            requestRecoveryButton.backgroundColor = .gray95
            
            APIDisposableChangePassword?.dispose()
            APIDisposableChangePassword = nil
            APIDisposableChangePassword = API.changePassword(oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!)
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { (response) in
                    Log.i("changePassword => onNext => \(response)")
                    DispatchQueue.main.async {
                        self.requestRecoveryButton.isEnabled = true
                        self.requestRecoveryButton.backgroundColor = .brandBlue
                        self.panToClose.animateDialogeDisappear() {
                        DialogueHelper.showStatusBarErrorMessage(message: "Password changed successfully", .brandGreen)
                        }
                    }
                    
                    //Login OK
                }, onError: { (error) in
                    Log.e("changePassword => onError => \(error) => \((error as NSError).domain)")
                    let customError = (error as NSError)
                    DispatchQueue.main.async {
                        self.requestRecoveryButton.isEnabled = true
                        self.requestRecoveryButton.backgroundColor = .brandBlue
                        
                    }
                    if customError.code == 403 {
                        DialogueHelper.showStatusBarErrorMessage(message: (customError.userInfo["error"] as? String) ?? "Error")
                    } else {
                        Log.e((customError.userInfo["msg"] as? String) ?? "Failed to change password")
                        StoringData.isLoggedIn = false
                        StoringData.password = ""
                        StoringData.email = ""
                        TabBarViewController.changeTabBarDelegate.changeTabBarIndex(index: 0)
                        DialogueHelper.showStatusBarErrorMessage(message: "Failed to change password")
                    }
                })
        } else {
            if !passwordsMatches {
                showPasswordNotMatchError()
            } else {
                showFillTheFieldsError()
            }
        }
    }
    
    func showPasswordNotMatchError(){
        Log.i()
        DialogueHelper.showStatusBarErrorMessage(message: "Passwords not match")
    }
    
    func showFillTheFieldsError(){
        Log.i()
        DialogueHelper.showStatusBarErrorMessage(message: "Fill the fields")
    }
    
    @IBAction func requestButtonDidTap(_ sender: Any) {
        doRequestRecoverAction()
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        panToClose.animateDialogeDisappear() {}
    }
    
}


extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == confirmNewPasswordTextField {
            if confirmNewPasswordTextField.text != newPasswordTextField.text {
                showPasswordNotMatchError()
                passwordsMatches = false
            } else {
                passwordsMatches = true
            }
        }
        allFieldsFilled = (oldPasswordTextField.text != "") && (newPasswordTextField.text != "") && (confirmNewPasswordTextField.text != "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            oldPasswordTextField.resignFirstResponder()
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            newPasswordTextField.resignFirstResponder()
            confirmNewPasswordTextField.becomeFirstResponder()
        } else if textField == confirmNewPasswordTextField {
            if textField == confirmNewPasswordTextField {
                if confirmNewPasswordTextField.text != newPasswordTextField.text {
                    showPasswordNotMatchError()
                    passwordsMatches = false
                } else {
                    passwordsMatches = true
                }
            }
            confirmNewPasswordTextField.resignFirstResponder()
            doRequestRecoverAction()
        }
        
        return true
    }
    
}
