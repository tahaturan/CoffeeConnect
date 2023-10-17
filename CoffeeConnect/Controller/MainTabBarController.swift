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
        discoverVC.tabBarItem = UITabBarItem(title: StringConstants.MainTabbar.discover, image: UIImage(systemName: AppStyleConstants.Icons.discover), tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: StringConstants.MainTabbar.profile, image: UIImage(systemName: AppStyleConstants.Icons.user), tag: 3)
        
        let controlers = [homeVC, searchVC, discoverVC, profileVC]
        self.viewControllers = controlers.map { UINavigationController(rootViewController: $0) }
    }
}
