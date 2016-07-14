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
    
    static let endpoint = "posts"
    
    static var url = NSURL(string: baseURL)?.URLByAppendingPathComponent(endpoint)
    
    var posts: [Post] {
        
        didSet {
            delegate?.postsUpdated(posts)
        }
    }
    
    // MARK: - Initializer(s)
    
    init() {
        
        self.posts = []
        
        fetchPosts{ (posts) in
            
            if let posts = posts {
                
                self.posts = posts
                
            }
        }
    }
    
    // MARK: - Method(s)
    
    func fetchPosts(reset: Bool = true, completion: ((posts: [Post]?) -> Void)? = nil) {
        
        let queryEndInterval = reset ? NSDate().timeIntervalSince1970 : posts.last?.queryTimestamp ?? NSDate().timeIntervalSince1970
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        
        let completeURL = PostController.url?.URLByAppendingPathExtension("json")
        
        guard let unwrappedURL = completeURL else {
            if let completion = completion {
                completion(posts: nil)
            }
            return
            
        }
        
        //        print("unwrappedURL = \(unwrappedURL)")
        
        NetworkController.performRequestForURL(unwrappedURL, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
            
            guard let data = data
                , jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String : AnyObject]
                else {
                    if let completion = completion {
                        completion(posts: nil)
                    }
                    return
            }
            
            var postsFromFeed: [Post] = []
            
            for (identifier, dictionary) in jsonDictionary {
                
                guard let dictionary = dictionary as? [String : AnyObject] else { break }
                
                if let post = Post(dictionary: dictionary, identifier: identifier) {
                    postsFromFeed.append(post)
                }
            }
            
            postsFromFeed = postsFromFeed.sort{ $0.timestamp > $1.timestamp }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if reset == true {
                    
                    self.posts = postsFromFeed
                    
                } else {
                    
                    self.posts.appendContentsOf(postsFromFeed)
                    
                }
                
                if let completion = completion {
                    
                    completion(posts: postsFromFeed)
                }
                
            })
        }
    }
    
    func addPost(username: String, text: String) {
        
        let post = Post(username: username, text: text)
        
        guard let url = post.endpoint else { return }
        
        print("\npost (description) = \(post.descriptionString)")
        
        print("\nurl for post call = \(url)")
        
        print("\npost.jsonData = \(post.jsonData)\n")
        
        /*
         guard let jsonDictionary = (try? NSJSONSerialization.JSONObjectWithData(post.jsonData!, options: [])) as? [String : AnyObject]
         else {
         
         print("JSON couldn't be deserialized")
         return
         
         }
         
         print("jsonDictionary (after deserialization) = \(jsonDictionary)")
         */
        
        
        NetworkController.performRequestForURL(url, httpMethod: .Put, body: post.jsonData) { (data, error) in
            
            let responseDataString = NSString(data: data!, encoding: NSUTF8StringEncoding) ?? ""
            
            if error != nil {
                
                print("Error (object): \(error)")
                
            } else if responseDataString.containsString("error") {
                
                print("Error (message): \(responseDataString)")
                
            } else {
                
                print("Successfully saved data to the endpoint.  \nResponse: \(responseDataString)")
                
            }
        }
        
        fetchPosts()
    }
    
}

protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
    
}