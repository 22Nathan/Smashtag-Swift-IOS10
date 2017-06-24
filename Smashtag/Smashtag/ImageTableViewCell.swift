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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var urlInfo: URL? = nil {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        if let url = urlInfo{
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.urlInfo{
                    DispatchQueue.main.async {
                        self?.tweetImage.image = UIImage(data: imageData)
                        self?.spinner.stopAnimating()
                    }
                }
            }
        }
        
    }
}
