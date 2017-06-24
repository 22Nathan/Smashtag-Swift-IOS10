//
//  UrlViewController.swift
//  Smashtag
//
//  Created by Nathan on 23/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class UrlViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var webUrl: URL? = nil{
        didSet{
            if webView?.window != nil{
                loadURL()
            }
        }
    }
    
    private func loadURL() {
        if webUrl != nil {
            let request = URLRequest(url: webUrl!)
            spinner.startAnimating()
            webView?.loadRequest(request)
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.delegate = self as? UIWebViewDelegate
        webView?.scalesPageToFit = true
        loadURL()
    }
    
    
    // MARK: - UIWebView delegate
    
    var activeDownloads = 0
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activeDownloads += 1
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activeDownloads -= 1
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }
}

