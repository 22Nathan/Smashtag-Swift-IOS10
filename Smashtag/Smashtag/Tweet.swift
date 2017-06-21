//
//  Tweet.swift
//  Smashtag
//
//  Created by Nathan on 17/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject
{
    class func findorCreateTweet(matching twitterInfo: Twitter.Tweet,in context: NSManagedObjectContext) throws -> Tweet
    {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@",twitterInfo.identifier)
        
        do{
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1,"Tweet.findOrCreateTweet -- database incosistency")
                return matches[0] //即在数据库已经存在这个Tweet
            }
        }catch{
            throw error
        }
        
        let tweet = Tweet(context:context) //未在数据库找到，即插入
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        tweet.tweeter = try? TwitterUser.findorCreateTwitterUser(matching: twitterInfo.user,in: context)
        return tweet
    }
}
