//
//  AppDelegate.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/10/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        log.debug(#function)
        configureViewController()
        
        return true
    }

    
    
    // MARK: - Configure ViewController
    
    private func configureViewController() {
        self.window = UIWindow()
        let controller = BaseNavigationController(rootViewController: LEGOMainViewController())
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }
}

