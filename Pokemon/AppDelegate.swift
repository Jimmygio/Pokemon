//
//  AppDelegate.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import UIKit
import SDWebImage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupSDImage()

        return true
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

    private func setupSDImage() {
        SDImageCache.shared.config.maxDiskSize = 100*1024*1024 // 100 MB
        SDImageCache.shared.config.maxDiskAge = 3600*24*7 // 1 week
        SDImageCache.shared.config.maxMemoryCost = 100*1024*1024 // 100 MB
        SDImageCache.shared.config.maxMemoryCount = 100
//        let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: Int64(SDImageCache.shared.totalDiskSize()), countStyle: .file)
//        SDImageCache.shared.diskCache.removeExpiredData() // 退背景會自動執行此Method
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SDImageCache.shared.memoryCache.removeAllObjects()
    }

}

