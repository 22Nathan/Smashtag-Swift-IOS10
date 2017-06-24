//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Nathan on 20/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewController: UITableViewController {
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    var tweet: Twitter.Tweet? {
        didSet{
            if let media = tweet?.media{
                if media.count > 0{
                    mentions.append(Mentions(title: "Images",data: media.map{MentionItem.Image($0.url, $0.aspectRatio)}))
                }
            }
            if let hashtag = tweet?.hashtags{
                if hashtag.count > 0{
                    mentions.append(Mentions(title: "HashTags",data: hashtag.map{
                        MentionItem.Keyword($0.keyword)
                    }))
                }
            }
            if let users = tweet?.userMentions{
                var userItems = [MentionItem.Keyword("@")]
                if users.count > 0 {
                    userItems += users.map { MentionItem.Keyword($0.keyword) }
                    mentions.append(Mentions(title: "Users", data: userItems))
                }
            }
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(title: "URLs",data: urls.map { MentionItem.Keyword($0.keyword) }))
                }
            }
        }
    }
    
    // MARK: - Model
    var mentions: [Mentions] = []
    
    struct Mentions
    {
        var title: String
        var data: [MentionItem]
    }
    
    enum MentionItem
    {
        case Keyword(String)
        case Image(URL,Double)
    }
    
    
    private func updateUI(){
        tableView.reloadData()
    }
    
    // MARK: - tableview method
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(let url,_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image Cell", for: indexPath) as! ImageTableViewCell
                cell.urlInfo = url
            return cell
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mention Cell", for: indexPath) as! MentionTableViewCell
            cell.tweetInfo = keyword
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK - segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Keyword"{
            if let cell = sender as? MentionTableViewCell{
                if let url = cell.mentionLabel.text{
                    if url.hasPrefix("http"){
//                        UIApplication.shared.open(URL(string: url)!)
                        performSegue(withIdentifier: "Url", sender: sender)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let identifier = segue.identifier{
            if identifier == "Keyword"{
                if let tweetMVC = destinationViewController as? TweetTableViewController{
                    if let cell = sender as? MentionTableViewCell{
                        tweetMVC.searchText = cell.mentionLabel.text
                    }
                }
            }
            else if identifier == "Image"{
                if let imageMVC = destinationViewController as? ImageViewController{
                    if let cell = sender as? ImageTableViewCell{
                        imageMVC.imageURL = cell.urlInfo
                    }
                }
            }
            else if identifier == "Url"{
                if let webMVC = destinationViewController as? UrlViewController{
                    if let cell = sender as? MentionTableViewCell{
                        let url = URL(string:cell.tweetInfo)
                        webMVC.webUrl = url
                    }
                }
            }
        }
    }
}
