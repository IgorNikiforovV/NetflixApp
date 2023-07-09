//
//  MainTabBarViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 08.07.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.title = "Home"
        
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc2.tabBarItem.title = "Coming soon"
        
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.title = "Top Search"
        
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        vc4.tabBarItem.title = "Downloads"
        
        tabBar.tintColor = .label

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}

