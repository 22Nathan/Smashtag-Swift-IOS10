//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Nathan on 22/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    var tweetImageInfo: UIImage? = nil { didSet{ updateUI() } }
    
    private func updateUI(){
        tweetImage.image = tweetImageInfo
    }
}
