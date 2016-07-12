//
//  Post.swift
//  Post
//
//  Created by Jeff Norton on 7/12/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import Foundation

struct Post {
    
    // MARK: - Stored Properties
    
    let username: String
    let text: String
    let timestamp: NSTimeInterval
    let id: NSUUID
    
    private let usernameKey = "username"
    private let textKey = "text"
    private let timestampKey = "timestamp"
    private let identifierKey = "identifier"
    
    // MARK: - Initializer(s)
    
    init(username: String, text: String) {
        
        self.username = username
        self.text = text
        self.timestamp = NSTimeInterval(NSTimeIntervalSince1970)
        self.id = NSUUID()
        
    }
    
    init?(dictionary: [String : AnyObject], identifier: String) {
        
        guard let username = dictionary[usernameKey] as? String
            , text = dictionary[textKey] as? String
            , timestamp = dictionary[timestampKey] as? NSTimeInterval
        else { return nil }
        
        self.username = username
        self.text = text
        self.timestamp = timestamp
        
        guard let identifier = NSUUID(UUIDString: identifier) else { return nil }
        
        self.id = identifier
        
        
    }
    
}