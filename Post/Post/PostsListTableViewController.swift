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
    
    // MARK: - PostControllerDelegate
    
    func postsUpdated(posts: [Post]) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        tableView.reloadData()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
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

}
