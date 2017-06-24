//
//  RecentSearchesTableViewController.swift
//  Smashtag
//
//  Created by Nathan on 24/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class RecentSearchesTableViewController: UITableViewController {
    
    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearchModel().values.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "History Cell", for: indexPath)
        
        cell.textLabel?.text = RecentSearchModel().values[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if let identifier = segue.identifier{
            if identifier == "Search"{
                if let tweetMVC = destinationViewController as? TweetTableViewController{
                    if let cell = sender as? UITableViewCell{
                        tweetMVC.searchText = cell.textLabel?.text
                    }
                }
            }
        }
    }

}
