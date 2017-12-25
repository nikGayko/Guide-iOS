//
//  TabBarController.swift
//  Guide-iOS
//
//  Created by Admin on 25.12.2017.
//  Copyright © 2017 Nikita Gayko. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //MARK: align tab bar item center vertical in tab bar

    private func setupTabBar() {
        if let tabBarItemArray = tabBar.items {
            for tabBarItem in tabBarItemArray {
                tabBarItem.title = nil
                tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
            }
        }
        
    }
}
