//
//  PostController.swift
//  Post
//
//  Created by Jeff Norton on 7/12/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import Foundation

class PostController {
    
    // MARK: - Stored Properties
    
    weak var delegate: PostControllerDelegate?
    
    static let baseURL = "https://devmtn-post.firebaseio.com/"
    
    static let endpoint = "posts.json"
    
    static var url = NSURL(string: baseURL)?.URLByAppendingPathComponent(endpoint)
    
    var posts: [Post] {
        
        didSet {
            delegate?.postsUpdated(posts)
        }
        
    }
    
    // MARK: - Initializer(s)
    
    init() {
        
        fetchPosts{ (posts) in
            
            if let posts = posts {
                
                self.posts = posts
                
            }

        }
        
    }
    
    // MARK: - Method(s)
    
    func fetchPosts(completion: (posts: [Post]?) -> Void) {
        
        guard let unwrappedURL = PostController.url else {
            
            completion(posts: nil)
            return
            
        }
        
        NetworkController.performRequestForURL(unwrappedURL, httpMethod: .Get) { (data, error) in
            
            guard let data = data
                , jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String : AnyObject]
                else {
                    
                    completion(posts: nil)
                    return
            }
            
            //            print("jsonDictionary = \(jsonDictionary)")
            
            var postsFromFeed: [Post] = []
            
            for (identifier, dictionary) in jsonDictionary {
                
                guard let dictionary = dictionary as? [String : AnyObject] else { break }
                
                if let post = Post(dictionary: dictionary, identifier: identifier) {
                    postsFromFeed.append(post)
                }
            }
            
            postsFromFeed = postsFromFeed.sort{ $0.timestamp > $1.timestamp }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.posts = postsFromFeed
                completion(posts: postsFromFeed)
                
            })
            
        }
        
    }
    
}

protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
    
}