//
//  MentionTableViewCell.swift
//  Smashtag
//
//  Created by Nathan on 21/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewCell: UITableViewCell {
    @IBOutlet weak var mentionLabel: UILabel!
    
    var tweetInfo : String = "" { didSet { updateUI() } }
    
    private func updateUI(){
        mentionLabel.text = tweetInfo
    }
    
}
