//
//  Router.swift
//  CommonUIKit
//
//  Created by Prince Mathew on 28/02/19.
//  Copyright © 2019 Coviam. All rights reserved.
//

import Foundation

public enum DeeplinkSource: String {
    case externalLink = "External"
    case internalLink = "Internal"
}

public class Router: NSObject, Codable {
    
    /// Regex pattern for matching given URL
    public var deeplinkRegex: String?
    
    public var deeplinkRegexList: [String]?
    
    /// Source of routing
    public var deeplinkSource: DeeplinkSource?
    
    /// Class(which confirms to router delegate) resposible for handling URL
    public var handlerClass: String?
    
    /// Actual Deeplink URL
    public var originalUrl: URL?
    
    /// Modified URL
    public var deeplinkUrl: URL?
    
    public var additionalParams: [String: Any]?
    
    enum CodingKeys: String, CodingKey {
        case deeplinkRegex
        case deeplinkRegexList
        case handlerClass
    }
    
    public override init() {
        super.init()
    }
}
