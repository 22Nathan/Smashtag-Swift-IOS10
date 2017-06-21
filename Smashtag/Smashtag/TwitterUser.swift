//
//  TwitterUser.swift
//  Smashtag
//
//  Created by Nathan on 17/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class TwitterUser: NSManagedObject {
    static func findorCreateTwitterUser(matching twitterInfo: Twitter.User,in context: NSManagedObjectContext) throws -> TwitterUser
    {
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@",twitterInfo.screenName)
        
        do{
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1,"TwitterUser.findOrCreateTwitterUser -- database incosistency")
                return matches[0] //即在数据库已经存在这个TwitterUser
            }
        }catch{
            throw error
        }
        
        let twitterUser = TwitterUser(context:context) //未在数据库找到，即插入
        twitterUser.handle = twitterInfo.screenName
        twitterUser.name = twitterInfo.name
        return twitterUser
    }
}
