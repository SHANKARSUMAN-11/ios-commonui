//
//  CommonWebViewController.swift
//  CommonUIKit
//
//  Created by Mayur Kothawade on 18/09/17.
//  Copyright © 2017 Coviam. All rights reserved.
//

import UIKit
import WebKit

public protocol CommonWebViewControllerDelegate: UIWebViewDelegate, WKNavigationDelegate {
    
    /// Use this method to load content in Webview
    func webViewReadyToLoadRequest(webView: WKWebView)
    
    /// Navigation title for the webview controller
    func navigationTitle() -> String?
    
    /// To display right bar button items
    func rightBarButtonItems(for controller: CommonWebViewController) -> [UIBarButtonItem]?
    
    func customBackButton() -> UIImage?
}

extension CommonWebViewControllerDelegate {
    func customBackButton() -> UIImage? {
        return nil
    }
}

public class CommonWebViewController: UIViewController, CustomBackButtonDelegate, LoadingProgressDelegate {

    var webView: WKWebView
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingProgressView: UIProgressView!
    let refreshControl = UIRefreshControl()
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.webView = WKWebView()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    var delegate: CommonWebViewControllerDelegate? {
        didSet {
            if let delegate = self.delegate {
                self.webDelegate = WKWebViewDelegate(delegate: delegate)
                self.webDelegate?.loadingProgressDelegate = self
            }
        }
    }
    var webDelegate: WKWebViewDelegate?

    public var dismissCompletion: (()->Void)?
    public var loadingProgressTimer: Timer?
    
    
    public convenience init (delegate: CommonWebViewControllerDelegate?) {
        self.init(nibName: "CommonWebViewController", bundle: Bundle(for: CommonWebViewController.self))
        self.setupDelegate(delegate: delegate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView()
        super.init(coder: aDecoder)
    }
    
    func setupDelegate(delegate: CommonWebViewControllerDelegate?) {
        self.delegate = delegate
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(self.pullToReferesh), for: .valueChanged)
        if let customBackButton = self.delegate?.customBackButton() {
            UtilityMethods.customBackButton(navigationController: navigationController, navigationItem: navigationItem, responder: self, image: customBackButton)
        } else {
            UtilityMethods.customBackButton(navigationController: navigationController, navigationItem: navigationItem, responder: self, image: nil)
        }
        
        let source: String = "var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; var head = document.getElementsByTagName('head')[0]; head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        // Create the user content controller and add the script to it
        let userContentController: WKUserContentController = WKUserContentController()
        userContentController.addUserScript(script)
        
        // Create the configuration with the user content controller
        let configuration: WKWebViewConfiguration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.applicationNameForUserAgent = "BlibliMobile"
        
        // Create the web view with the configuration
        self.webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        self.webView.scrollView.addSubview(self.refreshControl)
        self.contentView.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":self.webView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":self.webView]))

        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self.webDelegate
        self.webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.webView.contentMode = .scaleAspectFit
        self.webView.scrollView.bounces = true
        self.delegate?.webViewReadyToLoadRequest(webView: self.webView)
    }
    
    @objc func pullToReferesh(sender: AnyObject) {
        self.delegate?.webViewReadyToLoadRequest(webView: self.webView)
        sender.endRefreshing()
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.title = self.delegate?.navigationTitle()
        if let nvc = self.navigationController {
            nvc.navigationBar.isTranslucent = false
        }
        if let rightBarButtonItems = self.delegate?.rightBarButtonItems(for: self) {
            self.navigationItem.rightBarButtonItems = rightBarButtonItems
        }
    }
    
    override public var prefersStatusBarHidden: Bool {
        return false
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backToPreviousController() {
        if navigationController?.popViewController(animated: true) == nil {
            self.dismiss(animated: true, completion: nil)
        }
        if let dismissBlock = self.dismissCompletion {
            dismissBlock()
        }
    }
    
    
    //MARK: progress handler
    
    func initateLoadingProgressView() {
        self.loadingProgressView.progress = 0.0
        self.loadingProgressView.isHidden = false
        self.loadingProgressTimer = Timer.scheduledTimer(timeInterval: 0.001667, target: self, selector: #selector(self.loadingProgressTimerCallBack), userInfo: nil, repeats: true)
    }
    
    func isLoading() -> Bool {
        return !(self.webDelegate?.isWebViewLoaded ?? true)
    }
    
    @objc func loadingProgressTimerCallBack() {
        if self.isLoading() == true {
           
            self.loadingProgressView.progress += 0.0002
            if self.loadingProgressView.progress > 0.95 {
                self.loadingProgressView.progress = 0.95
            }
        } else {
            self.loadingProgressView.progress += 0.1
            if self.loadingProgressView.progress >= 1.0 {
                self.loadingProgressTimer?.invalidate()
                self.loadingProgressView.isHidden = true
            }
            
        }
    }
    
    
    //MARK: LoadingProgressDelegate
    
    func didStartLoading() {
        self.initateLoadingProgressView()
    }
    
    func setTitle(title: String?) {
        if self.title == "" {
            self.title = title
        }
    }
}

protocol LoadingProgressDelegate: NSObjectProtocol {
    func didStartLoading()
    func setTitle(title:String?)
}

class WebViewDelegate: NSObject, UIWebViewDelegate {
    var delegate: UIWebViewDelegate
    var isWebViewLoaded: Bool = false
    var loadingProgressDelegate: LoadingProgressDelegate?
    
    
    init(delegate: UIWebViewDelegate) {
        self.delegate = delegate
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return self.delegate.webView!(_: webView, shouldStartLoadWith: request, navigationType: navigationType)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.isWebViewLoaded = false
        self.loadingProgressDelegate?.didStartLoading()
        self.delegate.webViewDidStartLoad?(webView)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.isWebViewLoaded = true
        webView.scrollView.contentInset = .zero
        self.delegate.webViewDidFinishLoad?(webView)
    }
}

class WKWebViewDelegate: NSObject, WKNavigationDelegate {
    var delegate: WKNavigationDelegate
    var isWebViewLoaded: Bool = false
    var loadingProgressDelegate: LoadingProgressDelegate?
    
    
    init(delegate: WKNavigationDelegate) {
        self.delegate = delegate
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        return self.delegate.webView!(webView, decidePolicyFor:navigationAction, decisionHandler:decisionHandler)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.isWebViewLoaded = false
        self.loadingProgressDelegate?.didStartLoading()
        return self.delegate.webView!(webView, didStartProvisionalNavigation:navigation)
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            var webViewTitle = webView.title
            if let orRange = webViewTitle?.range(of: "|"), let endIndex = webViewTitle?.endIndex {
                webViewTitle?.removeSubrange(orRange.lowerBound..<endIndex)
            }
            if let HTTPStatus = (webViewTitle?.hasPrefix("http")), HTTPStatus || webViewTitle == "" {
                webViewTitle = webView.url?.lastPathComponent.capitalized
            }
            self.loadingProgressDelegate?.setTitle(title: webViewTitle)
        }
        
        self.isWebViewLoaded = true
        webView.scrollView.contentInset = .zero
        return self.delegate.webView!(webView, didFinish:navigation)
    }
}

extension CommonWebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let popup = WKWebView(frame: self.webView.frame, configuration: configuration)
            popup.uiDelegate = self
            self.webView.addSubview(popup)
            return popup
        }
        webView.load(navigationAction.request)
        return nil
    }
    
    public func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
    }
}
public extension WKWebView {
    public func height(completion:@escaping (CGFloat)->()) {
        
        self.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                
                self.evaluateJavaScript("document.body.scrollHeight;", completionHandler: { (height, error) in
                    if let height = height as? CGFloat {
                        return completion(height)
                    }
                })
            }
        })
    }
    
}


