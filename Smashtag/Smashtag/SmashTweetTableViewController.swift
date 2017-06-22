//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Nathan on 17/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController
{
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]){
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]){
        container?.performBackgroundTask{ context in  //backgroundTast用的context
            for twitterInfo in tweets{
                _ = try? Tweet.findorCreateTweet(matching: twitterInfo,in: context)
            }
            try? context.save()
        }
        printDatabase()
    }
    
    private func printDatabase(){
        if let context = container?.viewContext{ //main context
            let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            if let tweetCount = (try? context.fetch(request))?.count{
                print("\(tweetCount) tweets")
            }
            if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()){
                print("\(tweeterCount) twitter users") //如果fetch的结果
            }
        }
    }
    
    // MARK: - Navitation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term"{
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController{
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
        if segue.identifier == "Detail"{
            var destinationViewController = segue.destination
            if let navigationController = destinationViewController as? UINavigationController{
                destinationViewController = navigationController.visibleViewController ?? destinationViewController
            }
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let tweetForSegue: Twitter.Tweet = tweets[indexPath.section][indexPath.row]//获取sender的indexPath,然后获取segue的tweet
                if let mentionMVC = destinationViewController as? MentionTableViewController{
                    mentionMVC.navigationItem.leftBarButtonItem?.title = searchText!
                    mentionMVC.navigationItem.title = tweetForSegue.user.description
                    mentionMVC.tweet = tweetForSegue
                }
            }
        }
    }
}
