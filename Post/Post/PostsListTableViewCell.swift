//
//  PostsListTableViewCell.swift
//  Post
//
//  Created by Jeff Norton on 7/12/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import UIKit

class PostsListTableViewCell: UITableViewCell {
    
    // MARK: - Stored Properties
    
    weak var delegate: CustomCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - General

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Method(s)
    
    func updateWithPost(post: Post) {
        
        nameLabel.text = post.username
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .MediumStyle
        
        let date = NSDate(timeIntervalSinceReferenceDate: post.timestamp)
        
        let dateString = formatter.stringFromDate(date)
        
        contentLabel.text = "\(dateString) - \(post.text)"
        
    }

}

protocol CustomCellDelegate: class {
    
}