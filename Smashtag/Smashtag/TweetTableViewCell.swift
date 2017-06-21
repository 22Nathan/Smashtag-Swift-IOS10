//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Nathan on 23/04/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    // whenever our public API tweet is set
    // we just update our outlets using this method
    private func updateUI() {
        let para = tweet?.text
        let amountText = NSMutableAttributedString.init(string: para!)
        let hashtagAttribute = [ NSForegroundColorAttributeName: UIColor.blue ]
        let urlAttribute = [ NSForegroundColorAttributeName: UIColor.brown ]
        let userAttribute = [ NSForegroundColorAttributeName: UIColor.orange ]
        
//        for word in (tweet?.hashtags)!{
//            if (para?.contains(word.keyword))!{
//                let indexRange = para?.range(of: word.keyword)
//                let intRange = para?.nsRange(from: indexRange!)
//                amountText.setAttributes(hashtagAttribute, range: intRange!)
//            }
//        }
        
        for word in (tweet?.hashtags)!{
            let intRange = word.nsrange
            amountText.setAttributes(hashtagAttribute, range: intRange)
        }
        
        for word in (tweet?.userMentions)!{
            let intRange = word.nsrange
            amountText.setAttributes(userAttribute, range: intRange)
        }
        
        for word in (tweet?.urls)!{
            let intRange = word.nsrange
            amountText.setAttributes(urlAttribute, range: intRange)
        }
        
        tweetTextLabel?.attributedText = amountText
        tweetUserLabel?.text = tweet?.user.description
        if let profileImageURL = tweet?.user.profileImageURL {
            // FIXME: blocks main thread
            if let imageData = try? Data(contentsOf: profileImageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}

//extension String {
//    func nsRange(from range: Range<String.Index>) -> NSRange {
//        let from = range.lowerBound.samePosition(in: utf16)
//        let to = range.upperBound.samePosition(in: utf16)
//        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
//                       length: utf16.distance(from: from, to: to))
//    }
//}
