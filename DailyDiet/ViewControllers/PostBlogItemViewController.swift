//
//  PostBlogItemViewController.swift
//  DailyDiet
//
//  Created by ali on 6/12/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import RxSwift

class PostBlogItemViewController: BaseViewController {
    @IBOutlet weak var categoryTextFiield: DesignableTextField!
    @IBOutlet weak var titleTextField: DesignableTextField!
    @IBOutlet weak var summaryTexxtField: DesignableTextField!
    @IBOutlet weak var postButton: DesignableButton!
    @IBOutlet weak var contentTextView: DesignableTextView!
    
    
    var APIDisposablePostNewBlogItem: Disposable!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextFiield.delegate = self
        titleTextField.delegate = self
        summaryTexxtField.delegate = self
        contentTextView.delegate = self

    }
    
    
    @IBAction func postButtonDidTap(_ sender: Any) {
        postButton.backgroundColor  = .lightGray
        postButton.isEnabled = false
        
        APIDisposablePostNewBlogItem?.dispose()
        APIDisposablePostNewBlogItem = nil
        APIDisposablePostNewBlogItem = API.postBlogItem(category: categoryTextFiield.text!, content: contentTextView.text, slug: categoryTextFiield.text!, summary: summaryTexxtField.text!, title: titleTextField.text!)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("postBlogItem => onNext => \(response)")
                DispatchQueue.main.async {
                    self.postButton.backgroundColor  = .brandOrange
                    self.postButton.isEnabled = true
                    DialogueHelper.showStatusBarErrorMessage(message: response.msg, .darkGreen)
                    SegueHelper.popViewController(viewController: self)
                }
                
            }, onError: { (error) in
                Log.e("postBlogItem => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                DispatchQueue.main.async {
                    self.postButton.backgroundColor  = .brandOrange
                    self.postButton.isEnabled = true
                    
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed  to  post the blog")
                }
            })
    }
    
    
    @IBAction func backButtonDiidTap(_ sender: Any) {
        SegueHelper.popViewController(viewController: self)
    }
    
}

extension PostBlogItemViewController: UITextViewDelegate, UITextFieldDelegate {
    private func textFieldDidBeginEditing(_ textField: DesignableTextField) {
        textField.borderColor = .brandOrange
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case categoryTextFiield:
            categoryTextFiield.resignFirstResponder()
            titleTextField.becomeFirstResponder()
        case titleTextField:
            titleTextField.resignFirstResponder()
            summaryTexxtField.becomeFirstResponder()
        case summaryTexxtField:
            summaryTexxtField.resignFirstResponder()
            contentTextView.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    private func textFieldDidEndEditing(_ textField: DesignableTextField) {
        textField.borderColor = .lightGray
    }
}





