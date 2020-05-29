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

class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet var confirmNewPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var requestRecoveryButton: DesignableButton!
    @IBOutlet var panToClose: InteractionPanToClose!
    
    var APIDisposableChangePassword: Disposable!
    var passwordsMatches: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panToClose.setGestureRecognizer()
        
    }
    


    func doRequestRecoverAction(){
        Log.i()
        requestRecoveryButton.isEnabled = false
        requestRecoveryButton.backgroundColor = .gray95
        

        APIDisposableChangePassword.dispose()
        APIDisposableChangePassword = nil
        APIDisposableChangePassword = API.changePassword(oldPassword: ol, newPassword: <#T##String#>)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("userOTP => onNext => \(response)")


                DispatchQueue.main.async {
                    self.getCodeButton.isEnabled = true
                    self.indicatorView.isHidden = true
                    let vc = CodeVerificationViewController.instantiateFromStoryboardName(storyboardName: .Login)
                    vc.phoneNumber = "0\(self.phoneNumber)"
                    SegueHelper.pushViewController(sourceViewController: self, destinationViewController: vc)
                }

                //Login OK
            }, onError: { (error) in
                Log.e("userOTP => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)

                DispatchQueue.main.async {
                    self.getCodeButton.isEnabled = true
                    self.indicatorView.isHidden = true

                }

            })
        
    }
    
    func showPasswordNotMatchError(){
        Log.i()
        DialogueHelper.showStatusBarErrorMessage(message: "Passwords not match")
    }
    
    func fillTheFields(){
        Log.i()
        DialogueHelper.showStatusBarErrorMessage(message: "Fill the fields")
    }
    
    @IBAction func requestButtonDidTap(_ sender: Any) {
        
    }
}


extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == confirmNewPasswordTextField {
            if confirmNewPasswordTextField.text != newPasswordTextField.text {
                showPasswordNotMatchError()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            
        } else if textField == newPasswordTextField {
            
            newPasswordTextField.resignFirstResponder()
        } else if textField == confirmNewPasswordTextField {
            if textField == confirmNewPasswordTextField {
                if confirmNewPasswordTextField.text != newPasswordTextField.text {
                    showPasswordNotMatchError()
                }
            }
            confirmNewPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
}
