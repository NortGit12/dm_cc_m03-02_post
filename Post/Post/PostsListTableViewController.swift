//
//  PostsListTableViewController.swift
//  Post
//
//  Created by Jeff Norton on 7/12/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import UIKit

class PostsListTableViewController: UITableViewController, CustomCellDelegate, PostControllerDelegate {
    
    // MARK: - Stored Properties
    
    var postController = PostController()
    
    var posts: [Post] = []
    
    // MARK: - General

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postController.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        self.refreshControl?.addTarget(self, action: #selector(PostsListTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    // MARK: - Support Refresh
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    
    // MARK: - Action(s)
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        presentNewPostAlert()
        
    }
    
    
    // MARK: - PostControllerDelegate
    
    func postsUpdated(posts: [Post]) {
        
        postController.fetchPosts()
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("postsListCell", forIndexPath: indexPath) as? PostsListTableViewCell else { return UITableViewCell()}
        
        cell.delegate = self

        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.updateWithPost(post)

        return cell
    }
    
    // MARK: - Method(s)
    
    func presentNewPostAlert() {
        
        let postItemAlertController = UIAlertController(title: "New Post", message: "Update your status", preferredStyle: .Alert)
        
        postItemAlertController.addTextFieldWithConfigurationHandler { usernameTextField in
            
            usernameTextField.text = ""
            usernameTextField.placeholder = "Username..."
            
        }
        
        postItemAlertController.addTextFieldWithConfigurationHandler { messageTextField in
            
            messageTextField.text = ""
            messageTextField.placeholder = "Message..."
            
        }
        
        let postItemAction = UIAlertAction(title: "Post", style: .Default) { (action) in
            
            guard let usernameTextField = postItemAlertController.textFields?[0]
                , username = usernameTextField.text
                , itemTextField = postItemAlertController.textFields?[1]
                , message = itemTextField.text
                else { return }
            
            if username.characters.count == 0 || message.characters.count == 0 {
                
                self.presentErrorAlert()
                
            } else {
            
                self.postController.addPost(username, text: message)
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        postItemAlertController.addAction(postItemAction)
        postItemAlertController.addAction(cancelAction)
        
        presentViewController(postItemAlertController, animated: true, completion: nil)
        
    }
    
    func presentErrorAlert() {
        
        let alertController = UIAlertController(title: "Missing Information", message: "Required information is missing (username and/or message).  Enter the required text and try again.", preferredStyle: .Alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again", style: .Default) { placeholder in
            
            self.presentNewPostAlert()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

}
