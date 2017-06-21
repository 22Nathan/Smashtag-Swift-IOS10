//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Nathan on 20/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MentionTableViewController: UITableViewController {
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
}
