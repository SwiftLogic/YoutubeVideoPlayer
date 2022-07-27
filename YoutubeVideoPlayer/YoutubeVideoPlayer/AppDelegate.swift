//
//  AppDelegate.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 7/27/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpNavBarAppearance()
        setUpTabBarAppearance()
        return true
    }

    
    
    func setUpNavBarAppearance() {
        // setup navBar.....
        UINavigationBar.appearance().barTintColor = APP_BACKGROUND_COLOR
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        fix_iOS_15_NavBarBug()
    }
    
    
    
    fileprivate func setUpTabBarAppearance() {
        //setup tabbar
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = APP_BACKGROUND_COLOR
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
           UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        handleFix_iOS_15_TabBarBug()
    }
    
    
    
    fileprivate func handleFix_iOS_15_TabBarBug() {
        //disables automatic transparent tabBar in iOS 15
        if #available(iOS 13.0, *) {
//            //fixes
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = APP_BACKGROUND_COLOR
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            if #available(iOS 15.0, *) {
                //fixes iOS 15 BadgeTextAttributes
                let tabBarItemAppearance = UITabBarItemAppearance()
                tabBarItemAppearance.normal.badgeTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 12, weight: .semibold)]
                tabBarItemAppearance.normal.badgeBackgroundColor = .red
                tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }

    
    
    
    fileprivate func fix_iOS_15_NavBarBug() {
        //Fix Nav Bar tint issue in iOS 15.0 or later
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.shadowColor = UIColor.clear//lineSeperatorColor//baseWhiteColor //UIColor.clear // Effectively removes the border
//             appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
            appearance.backgroundColor = APP_BACKGROUND_COLOR
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }

    }

    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

