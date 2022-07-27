//
//  MainTabbarVC.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit
class MainTabbarVC: UITabBarController {
    
    
    //MARK: - View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    //MARK: - Properties
    
    lazy var homeController = handleCreateTab(with: HomeVC(), title: "Home", selectedImage: HOME_SELECTED_IMAGE, image: HOME_UNSELECTED_IMAGE)
    
    lazy var shortsController = handleCreateTab(with: HomeVC(), title: "Shorts", selectedImage: SHORTS_SELECTED_IMAGE, image: SHORTS_IMAGE)

    lazy var createController = handleCreateTab(with: HomeVC(), title: nil, selectedImage: CREATE_POST_IMAGE, image: CREATE_POST_IMAGE)
    
    lazy var subsController = handleCreateTab(with: HomeVC(), title: "Subscriptions", selectedImage: SUBSCRIPTION_SELECTED_IMAGE, image: SUBSCRIPTION_UNSELECTED_IMAGE)
    
    lazy var libraryController = handleCreateTab(with: HomeVC(), title: "Library", selectedImage: LIBRARY_SELECTED_IMAGE, image: LIBRARY_UNSELECTED_IMAGE)
    
    

    
    
    //MARK: - Methods
    fileprivate func setUpViews() {
        
        viewControllers = [homeController, shortsController, createController, subsController, libraryController]
    
    }
    
    
    
    
    
    fileprivate func handleCreateTab(with controller: UIViewController, title: String?, selectedImage: UIImage?, image: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.tintColor = .white
        return navController
        
    }
    
}

