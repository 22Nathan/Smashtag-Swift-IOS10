//
//  ImageViewController.swift
//  Cassini
//
//  Created by Nathan on 25/03/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
    var imageURL: URL?{
        didSet{
            image = nil
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! //对spinner的weak reference 
    private func fetchImage(){
        if let url = imageURL{
            //closure指向imageviewController
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL{ //url是要更新的url，self.imageURL是目前imageVC的url，若不一致，则忽略
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            // to zoom we have to handle viewForZooming(in scrollView:)
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage?{  //for imageView
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating() //处于prepare时，outlet未初始化
        }
    }
    
}
// MARK: UIScrollViewDelegate
// Extension which makes ImageViewController conform to UIScrollViewDelegate
// Handles viewForZooming(in scrollView:)
// by returning the UIImageView as the view to transform when zooming
extension ImageViewController : UIScrollViewDelegate   //UIScrolViewDelegate会遵循这个protocol，所以改变这个函数，使其放大是放大这个image
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
