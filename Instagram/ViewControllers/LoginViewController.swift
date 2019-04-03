//
//  ViewController.swift
//  github
//
//  Created by Chung Tran on 26/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import JGProgressHUD

class LoginViewController: UIViewController, StoryboardInitializableViewController {
    // MARK: - subviews
    var webView: WKWebView!
    let hud = JGProgressHUD(style: .dark)
    
    // MARK: - Properties
    private let bag = DisposeBag()
    let authURL = "https://api.instagram.com/oauth/authorize/?client_id=\(InstagramAPI.clientID)&response_type=code&redirect_uri=\(InstagramAPI.redirectURL)"
    lazy var urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(urlRequest)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func reload(_ sender: Any) {
        webView.load(urlRequest)
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        hud.textLabel.text = "Loading..."
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.show(in: view)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hud.textLabel.text = "Something went wrong, please try again later"
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: view)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            // handle code return from redirectURL
            if let range = url.range(of: "?code=") {
                let code = url[range.upperBound...]
                // login with code
                InstagramAPI.standard.loginWithCode(String(code))
                    .subscribe { (error) in
                        debugPrint(error)
                        
                        self.hud.textLabel.text = "Can not login, please try again later"
                        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud.isUserInteractionEnabled = false
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2)
                        
                        // reload login page
                        webView.load(self.urlRequest)
                    }
                    .disposed(by: bag)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}

