//
//  AboutUsViewController.swift
//  DailyDiet
//
//  Created by ali on 6/12/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: BaseViewController {
    
    @IBOutlet weak var vwWebView: UIView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var url: String = "https://daily-diet-aut.herokuapp.com/about"
    var webView: WKWebView!
    var titleName: String!
    var isPresented: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: vwWebView.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        webView.load(urlRequest)
        
        
        // add activity
        //        self.webView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.webView.navigationDelegate = self
        self.activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.color = .brandOrange
    }

    
    @IBAction func backButtonDidTap(_ sender: Any) {
        if isPresented {
            self.dismiss(animated: true, completion: nil)
        } else {
            SegueHelper.popViewController(viewController: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if webView.frame.origin.y > 0 {
            webView.frame = CGRect(x: 0,
                                   y: 0,
                                   width: vwWebView.frame.width,
                                   height: vwWebView.frame.height)
            vwWebView.addSubview(webView)
            
        }
    }
}

extension AboutUsViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
    }
}
