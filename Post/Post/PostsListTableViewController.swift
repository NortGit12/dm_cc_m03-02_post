//
//  PostsListTableViewController.swift
//  Post
//
//  Created by Jeff Norton on 7/12/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import UIKit

class PostsListTableViewController: UITableViewController, PostControllerDelegate {
    
    // MARK: - Stored Properties
    
    var postController = PostController()
    
    // MARK: - General

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        postController.delegate = self
    }
    
    // MARK: - PostControllerDelegate
    
    func postsUpdated(posts: [Post]) {
        
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postsListCell", forIndexPath: indexPath)

        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.textLabel?.text = post.username
        cell.detailTextLabel?.text = post.text

        return cell
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
