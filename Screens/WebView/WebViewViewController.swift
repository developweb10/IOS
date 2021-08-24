//
//  WebViewViewController.swift
//  Find Me
//
//  Created by Developer on 12/22/20.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    let webView = WKWebView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.frame = self.view.frame
        self.view.addSubview(self.webView)
        webView.navigationDelegate = self
        
        if let url = URL(string: "http://182.73.95.220/findme/Api/privacyPolicy") {
            self.webView.load(URLRequest(url: url))
        }
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    

    

}

extension WebViewViewController: WKNavigationDelegate, WKUIDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let textSize = 300
        let javascript = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(textSize)%'"
        webView.evaluateJavaScript(javascript) { (response, error) in
            print()
        }
    }

}
  
