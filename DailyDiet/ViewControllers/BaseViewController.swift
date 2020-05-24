

import UIKit
import SwiftValidator
import VisualEffectView
import IQKeyboardManagerSwift
class BaseViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let validator = Validator()
    var initialInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    var textfieldDistances = [Int:CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        registerTextFieldValidations()
        setupViews()
        configureViews()
        initialInteractivePopGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
    }


    func listenToNotificationCenterObservers() { }
    func removeNotificationCenterObservers() { }

    func addKeyboardHandleGesture(){
        Log.i()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard)))
        setupViews()
    }

    func createBottomDarkLayer() {
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        let darkViewBottom = UIView(frame: frame)
        darkViewBottom.tag = 42
        darkViewBottom.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(removeBottomSubView))
        darkViewBottom.addGestureRecognizer(dismissGesture)
        self.view.addSubview(darkViewBottom)
    }
    func removeBottomDarkLayer() {
        for each in view.subviews {
            if each.tag == 42 {
                each.removeFromSuperview()
            }
        }
    }


    @objc func removeBottomSubView() {
        removeBottomDarkLayer()
        self.view.viewWithTag(89)?.removeFromSuperview()
    }

    override func viewWillAppear(_ animated: Bool) {
        configureViews()
//        setupKeyboardDistance()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = initialInteractivePopGestureRecognizerDelegate
        listenToNotificationCenterObservers()
        removeNotificationCenterObservers()
    }

    func setupViews(){

    }
    func configureViews(){
    }

    func setupKeyboardDistance(textField:UITextField) {
        if let dictionary = StoringData.keyboardDistances {
            if let value = dictionary[String(describing:textField.tag)] {
                if let valueInt = value as? CGFloat {
                    IQKeyboardManager.shared.keyboardDistanceFromTextField = valueInt
                }
               
            }
        }else{
            let distance = textField.frame.origin.y - self.view.frame.origin.y
            StoringData.keyboardDistances = [String(describing: textField.tag):distance]
            IQKeyboardManager.shared.keyboardDistanceFromTextField = distance
        }
    }



    @objc func hideKeyboard(){
        Log.i()
        self.view.endEditing(true)
    }


    func registerTextFieldValidations(){
        Log.i()

        validator.styleTransformers(success:{ (validationRule) -> Void in
            Log.i("\(validationRule.field.self) => Successful")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""

            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            } else if let textField = validationRule.field as? UITextView {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            }
        }, error:{ (validationError) -> Void in
            Log.e("\(validationError.field.self) => Failed")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            } else if let textField = validationError.field as? UITextView {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })

    }
    
    func doShakeFunction(){
        Log.i()
        
    }
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            UIView.animate(withDuration: 0.4) {
                self.doShakeFunction()
            }
        }
    }
}


extension BaseViewController: ValidationDelegate {
    func validationSuccessful() {
        Log.i("Validation Successful")
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        Log.e("Validation Failed")
    }
}
extension UIViewController {
    func addBlurView(bottomMargin:CGFloat = 0) {
         let blurView = VisualEffectView()
        blurView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - bottomMargin)
        blurView.colorTint = .black
        blurView.colorTintAlpha = 0.2
        blurView.tag = 42
        blurView.blurRadius = 5
        blurView.scale = 1
        blurView.alpha = 0
        view.addSubview(blurView)
        UIView.animate(withDuration: 0.5) {
           blurView.alpha = 1
        }
    }

    func removeBlurView() {
        for each in view.subviews {
            if each.tag == 42 {
                UIView.animate(withDuration: 0.2, animations: {
                    each.alpha = 0
                }) { (success) in
                    if success == true {each.removeFromSuperview()}
                }
            }
        }
    }
}
