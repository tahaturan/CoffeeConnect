//
//  MainTabBarController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    //MARK: - Properties
    private let homeVC = HomeViewController()
    private let discoverVC = DiscoverViewController()
    private let profileVC = ProfileViewController()
    private let searchVC = SearchViewController()
    private let postVC = PostViewController()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    


}
//MARK: - Helper
extension MainTabBarController {
    func setupTabBar() {
        
        homeVC.tabBarItem = UITabBarItem(title: StringConstants.MainTabbar.home, image: UIImage(systemName: AppStyleConstants.Icons.home), tag: 0)
        searchVC.tabBarItem = UITabBarItem(title: StringConstants.MainTabbar.search, image: UIImage(systemName: AppStyleConstants.Icons.search), tag: 1)
        postVC.tabBarItem = UITabBarItem(title: StringConstants.MainTabbar.post, image: UIImage(systemName: AppStyleConstants.Icons.post), tag: 2)
        discoverVC.tabBarItem = UITabBarItem(title: StringConstants.MainTabbar.discover, image: UIImage(systemName: AppStyleConstants.Icons.discover), tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: StringConstants.MainTabbar.profile, image: UIImage(systemName: AppStyleConstants.Icons.user), tag: 4)
        
        let controlers = [homeVC, searchVC, postVC, discoverVC, profileVC]
        self.viewControllers = controlers.map { UINavigationController(rootViewController: $0) }
    }
}
