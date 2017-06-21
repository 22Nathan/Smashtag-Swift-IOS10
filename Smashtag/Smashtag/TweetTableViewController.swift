//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Nathan on 22/04/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController,UITextFieldDelegate {
    // MARK: - Table view data source

    private var tweets = [Array<Twitter.Tweet>](){
        didSet{
            print(tweets)
        }
    }
    
    public var searchText: String?{
        didSet{
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            self.navigationItem.title = searchText
        }
    }
    
    internal func insertTweets(_ newTweets: [Twitter.Tweet]){
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: .fade)
    }
    
    private func twitterRequest() -> Twitter.Request?{
        if let query = searchText, !query.isEmpty{
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest : Twitter.Request?
    
    private func searchForTweets(){
        if let request = lastTwitterRequest?.newer ?? twitterRequest(){
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest{
                        self?.insertTweets(newTweets)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
//        }
        }else{
            self.refreshControl?.endRefreshing()
        }
    }


    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
//        searchText = "#stanford"
    }
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
        }
    }
    
    // when the return (i.e. Search) button is pressed in the keyboard
    // we go off to search for the text in the searchTextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        let tweet: Twitter.Tweet = tweets[indexPath.section][indexPath.row]
        // Configure the cell...
        // the textLabel and detailTextLabel are for non-Custom cells
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name

        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // make it a little clearer when each pull from Twitter
        // occurs in the table by setting section header titles
        return "\(tweets.count-section)"
    }
}
