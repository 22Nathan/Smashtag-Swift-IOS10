//
//  MyTabBarViewController.swift
//  Smashtag
//
//  Created by Nathan on 24/06/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class MyTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.darkGray
        
        let image_1 = #imageLiteral(resourceName: "search.png").withRenderingMode(.alwaysOriginal)
        let tabBarItem_1 = UITabBarItem(title: nil, image: image_1,selectedImage: nil)
        tabBarItem_1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.viewControllers?[0].tabBarItem = tabBarItem_1
        
        let image_2 = #imageLiteral(resourceName: "history.png").withRenderingMode(.alwaysOriginal)
        let tabBarItem_2 = UITabBarItem(title: nil, image: image_2,selectedImage: nil)
        tabBarItem_2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.viewControllers?[1].tabBarItem = tabBarItem_2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
