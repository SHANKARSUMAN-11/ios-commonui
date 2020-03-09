//
//  CommonRouter.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 28/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation
import JavaScriptCore

public typealias RouterCompletion = (_ controller: UIViewController?,_ isHandled: Bool,_ isNavigationBarHidden: Bool) -> ()


/// Delegate method to be implemented by handler classes
public protocol RouterDelegate: class {
    static func handleRouting(for router: Router,with completionBlock: @escaping RouterCompletion)
}


/// This class is responsible for all the routing in application
public class CommonRouter: NSObject {
    
    fileprivate lazy var jsContext: JSContext? = {
        let context = JSContext()
        guard let jSPath = RouterManager.sharedInstance.jsPath else {
            return nil
        }
        
        do {
            let jsFunction = try String(contentsOfFile: jSPath, encoding: String.Encoding.utf8)
            _ = context?.evaluateScript(jsFunction)
        } catch (let error) {
            return nil
        }
        return context
    }()
    
    public override init() {
        super.init()
    }
    
   /// Handle routing for deeplink URL's
   ///
   /// - Parameters:
   ///   - url: Deeplink URL
   ///   - source: Specifies if routing source is InApp or External(push notification/ads)
   ///   - completionBlock: Returns if the URL is handled/not handled
    public func handleRouting(for url: URL,from source: DeeplinkSource = .externalLink, additionalParams: [String:Any]? = nil,with completionBlock:((Bool)->Void)? = nil) {
        guard RouterManager.sharedInstance.shouldActivateRouting else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                self.handleRouting(for: url, from: source, additionalParams: additionalParams, with: completionBlock)
            }
            return
        }
        getRouter(for: url) { (_router) in
            guard let _ = _router else {
                completionBlock?(false)
                return
            }
            _router?.additionalParams = additionalParams
            _router?.deeplinkSource = source
            self.openScreen(for: _router!, from: source)
            completionBlock?(true)
        }
    }
    
    /// Handle Routing to classes
    ///
    /// - Parameters:
    ///   - targetClass: class which implements the router delegate
    ///   - source: Specifies if routing source is InApp or External(push notification/ads)
    ///   - additionalParams: if any
    ///   - completionBlock: Returns if the URL is handled/not handled
    public func handleRouting(to targetClass: AnyClass,from source: DeeplinkSource = .externalLink,additionalParams: [String:Any]? = nil,with completionBlock:((Bool)->Void)? = nil) {
        let handlerClass = String(describing: targetClass.self)
        
        guard RouterManager.sharedInstance.shouldActivateRouting else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                self.handleRouting(to: targetClass, from: source, additionalParams: additionalParams, with: completionBlock)
            }
            return
        }
        
        guard let _ = UtilityMethods.getClass(from: handlerClass) as? RouterDelegate.Type else {
            completionBlock?(false)
            return
        }
        
        let router = Router()
        router.additionalParams = additionalParams
        router.handlerClass = handlerClass
        self.callDelegate(of: handlerClass, with: router)
        
        completionBlock?(true)
    }
    
    
    /// If JS is available for on the fly changes, return modified URL
    ///
    /// - Parameter urlString: Deeplink URL
    /// - Returns: Modified URL
    private func hasValidJavaScriptRouter(for urlString: String) -> URL? {
        
        guard let context = jsContext else {
            return nil
        }
        
        let routerFunction = context.objectForKeyedSubscript(RouterManager.sharedInstance.jsFunctionName)
        guard let routerResult = routerFunction?.call(withArguments: [urlString]),
            let routerResultdata = routerResult.toString()?.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        guard let destinationUrl = String(data: routerResultdata, encoding: .utf8),
            !destinationUrl.isEmpty else {
            return nil
        }
        
        guard let encodedString = destinationUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let deeplinkUrl = URL(string: encodedString) else {
            return nil
        }
        return deeplinkUrl
    }
    
    public func getRouter(for url: URL, completion: @escaping ((Router?)->Void)) {
        if let jsUrl = self.hasValidJavaScriptRouter(for: url.absoluteString),
            let router = fetchHandler(for: jsUrl) {
            router.originalUrl = url
            completion(router)
        } else {
            if let router = fetchHandler(for: url) {
                router.originalUrl = url
                completion(router)
            } else {
                self.getAlternateLink(for: url) { (redirectUrl) in
                    if let redirectUrl = redirectUrl {
                        self.getRouter(for: redirectUrl, completion: completion)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    private func fetchHandler(for url: URL) -> Router? {
        guard let router = RouterManager.sharedInstance.fetchRouter(for: url),
            let handlerClass = router.handlerClass,
            let _ = UtilityMethods.getClass(from: handlerClass) as? RouterDelegate.Type else {
                return nil
        }
        router.deeplinkUrl = url
        return router
    }
    
    private func openScreen(for router: Router,from source: DeeplinkSource) {
        
        guard RouterManager.sharedInstance.shouldActivateRouting else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                self.openScreen(for: router, from: source)
            }
            return
        }
        
        guard let handlerClass = router.handlerClass else {
            return
        }
        self.callDelegate(of: handlerClass, with: router)
    }
    
    private func callDelegate(of handlerClass: String, with router: Router) {
        
        guard let topMost = UIApplication.topMost else {
            return
        }
        
        guard let routerDelegate = UtilityMethods.getClass(from: handlerClass) as? RouterDelegate.Type else {
            return
        }
        
        routerDelegate.handleRouting(for: router) { (viewController, isHandled, isNavigationBarHidden) in
            if let controller = viewController,
                (topMost.presentingViewController == nil ||
                    topMost.navigationController?.view.frame.size.width == topMost.view.window?.rootViewController?.view.frame.size.width) {
                DispatchQueue.main.async {
                    topMost.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    ///Fetch alternate link from either 301 redirect or Alternate link in page HTML
    private func getAlternateLink(for url: URL, completionBlock: @escaping (URL?)->()) {
        CustomUrlSession.checkIfItRedirects(url: url) { (redirectUrl) in
            if let redirectUrl = redirectUrl {
                completionBlock(redirectUrl)
            } else {
                self.appLinkFromURLContent(url: url) { (appLink) in
                    if !appLink.isEmpty,
                        let appLinkUrl = URL(string: appLink) {
                        completionBlock(appLinkUrl)
                    } else {
                        completionBlock(nil)
                    }
                }
            }
        }
    }
    
    ///Fetch alternate link from HTML
    private func appLinkFromURLContent(url: URL, completionBlock: @escaping ((String)->())) {
        DispatchQueue.global(qos: .background).async(execute: {
            var appLink = ""
            var htmlString = ""
            do {
                htmlString = try NSString.init(contentsOf: url,
                                               encoding: String.Encoding.ascii.rawValue) as String
            }
            catch let error as NSError {
                print(error)
            }
            
            if let androidAppLowerBound = (htmlString.range(of: RouterManager.sharedInstance.webDeeplinkScheme)?.lowerBound) {
                appLink = String(htmlString[androidAppLowerBound...])
                if let slashLowerBound = (appLink.range(of: "\"")?.lowerBound) {
                    appLink = String(appLink[..<slashLowerBound])
                    appLink = appLink.replacingOccurrences(of: RouterManager.sharedInstance.webDeeplinkScheme, with: RouterManager.sharedInstance.deeplinkScheme)
                    if let ignorePath = RouterManager.sharedInstance.ignorePath {
                        appLink = appLink.replacingOccurrences(of: ignorePath, with: "")
                    }
                }
                
                if let query = url.query,
                    query.count > 0 {
                    appLink.contains("?") ? appLink.append("&\(query)") : appLink.append("?\(query)")
                }
            }
            DispatchQueue.main.async(execute: {
                completionBlock(appLink)
            })
        })
    }
    
}


public extension UIApplication {
    
    /// Returns the current application's top most view controller.
    @objc public class var topMost: UIViewController? {
        let topMost = self.topMost(of: UIApplication.shared.keyWindow?.rootViewController)
        if #available(iOS 13.0, *) {
            topMost?.isModalInPresentation = true
        }
        return topMost
    }
    
    /// Returns the top most view controller from given view controller's stack.
    @objc public class func topMost(of viewController: UIViewController?) -> UIViewController? {
        
        if let navigationVC = viewController as? UINavigationController,
            let topViewController = navigationVC.topViewController {
            return self.topMost(of:topViewController)
        } else if viewController?.isKind(of: UITabBarController.self) == true,
            let tabBarController = viewController as? UITabBarController, !RouterManager.sharedInstance.ignoreChildForTopMost {
            return self.topMost(of: tabBarController.selectedViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        } else if let childVCs = viewController?.children,
            !childVCs.isEmpty, !viewController!.isKind(of: CommonTableViewController.self), !RouterManager.sharedInstance.ignoreChildForTopMost {
            return self.topMost(of:childVCs.last)
        }
        return viewController
    }
    
    /// A Recursive function which can Pop and Dismiss any ViewController to the Root ViewController
    /// 
    /// - Parameters:
    ///   - animated: If you want to add animation
    ///   - completion: Completion Block will be executed after all controllers are gone
    public static func popAndDismissToRootViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        CATransaction.begin()
        // if something is preseneted
        if UIApplication.topMost?.presentingViewController != nil {
            UIApplication.topMost?.dismiss(animated: false, completion: {
                UIApplication.popAndDismissToRootViewController(animated: animated, completion)
            })
        } else {
            CATransaction.setCompletionBlock(completion)
            UIApplication.topMost?.navigationController?.popToRootViewController(animated: animated)
        }
        CATransaction.commit()
    }
}


/// Fetch the redirect URL for the given URL
fileprivate class CustomUrlSession: NSObject, URLSessionTaskDelegate {
    var redirectUrl: URL?
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        redirectUrl = request.url
        var newRequest = request
        newRequest.url = redirectUrl
        completionHandler(newRequest)
    }
    
    class func checkIfItRedirects(url: URL, completion: @escaping (_ redirectUrl: URL?) -> Void) {
        let delegate : CustomUrlSession = CustomUrlSession()
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
        session.dataTask(with: url) { (data, response, error) in
            completion(delegate.redirectUrl)
            }.resume()
    }
}
