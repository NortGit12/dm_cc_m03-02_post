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
    let identifier: NSUUID
    
    private let usernameKey = "username"
    private let textKey = "text"
    private let timestampKey = "timestamp"
    private let identifierKey = "identifier"
    
    var dateString: String {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .MediumStyle
        
        let date = NSDate(timeIntervalSince1970: timestamp)
        
        return formatter.stringFromDate(date)
        
    }
    
    var endpoint: NSURL? {
        
        guard let url = PostController.url else { return nil }
        
        return url
            .URLByAppendingPathComponent(identifier.UUIDString)
            .URLByAppendingPathExtension("json")
        
    }
    
    var dictionaryValue: [String : AnyObject] {
        
        return [usernameKey: username, textKey: text, timestampKey: timestamp]
        
    }
    
    var jsonData: NSData? {
        
        return try? NSJSONSerialization.dataWithJSONObject(dictionaryValue, options: .PrettyPrinted)
        
    }
    
    var descriptionString: String {
        return "\(usernameKey) = \(username), \(textKey) = \(text), timestamp as dateString = \(dateString), \(identifierKey) (UUIDString) = \(identifier.UUIDString)"
    }
    
    var queryTimestamp: NSTimeInterval {
        
        return timestamp - 1
        
    }
    
    // MARK: - Initializer(s)
    
    init(username: String, text: String) {
        
        self.username = username
        self.text = text
        self.timestamp = NSDate().timeIntervalSince1970
        self.identifier = NSUUID()
        
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
        
        self.identifier = identifier
        
        
    }
    
}