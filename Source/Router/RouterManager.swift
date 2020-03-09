//
//  RouterManager.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 28/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation

/// RouterManager is responsible for maintaining the routing registry and returning the router responsible for handling any given URL. This singleton class needs to be intialized in app delegate for the routing logic to perform

public class RouterManager: NSObject {
    
    private var RouterRegistry = [Router]()
    
    //Specify the deeplink scheme of app eg: google://
    public var deeplinkScheme = ""
    
    //Specify the app deeplink scheme provided in website alternate link
    //Eg: android-app://product/BLH-15012-07334
    public var webDeeplinkScheme = ""
    
    //Ignorable paths in the web alternate link
    public var ignorePath: String?
    
    //Javascript file path for deeplink handling
    public var jsPath: String?
    
    //JS function name
    public var jsFunctionName = ""
    
    public static var sharedInstance = RouterManager()
    
    private override init() {
        super.init()
    }
    
    public var ignoreChildForTopMost : Bool = true
    
    public var shouldActivateRouting : Bool = true
    /// Load the Routing registry from json file in app bundle/documents directory
    ///
    /// - Parameter path: Json file path
    public func fetchRoutingList(from path: String) -> Bool {
        if self.RouterRegistry.count == 0,
            let deeplinkList = try? String.init(contentsOfFile: path, encoding: String.Encoding.utf8),
            let data = deeplinkList.data(using: .utf8),
            let deeplinkArray = try? JSONDecoder().decode([Router].self, from: data) {
            self.RouterRegistry = deeplinkArray
            return true
        }
        return false
    }
    
    
    /// LOad the routing registry from the model object
    ///
    /// - Parameter registry: Router array object
    public func fetchRoutingList(from registry: [Router]) {
        self.RouterRegistry = registry
    }
    
    /// Checks if there's a matching router object for the given url & returns the same if any
    ///
    /// - Parameter url: Deeplink URL
    /// - Returns: Router object responsible for handling the URL
    internal func fetchRouter(for url: URL) -> Router? {
        let rtr = RouterRegistry.first(where: { (router) -> Bool in
            
            if let deeplinkRegex = router.deeplinkRegex?.lowercased(),
                let _ = url.absoluteString.lowercased().range(of: deeplinkRegex, options: .regularExpression, range: nil, locale: nil) {
                return true
            }
            if let deeplinkRegexList = router.deeplinkRegexList {
                var match = false
                deeplinkRegexList.forEach { (deeplink) in
                    if let _ = url.absoluteString.lowercased().range(of: deeplink.lowercased(), options: .regularExpression, range: nil, locale: nil) {
                        match = true
                    }
                }
                if match {
                    return true
                }
            }
            return false
        })
        return rtr
    }
    
    public func isSupportedUrl(url: URL) -> Bool {
        return self.fetchRouter(for: url) != nil
    }
    

}
