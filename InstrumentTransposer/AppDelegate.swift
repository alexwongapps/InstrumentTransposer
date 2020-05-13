//
//  AppDelegate.swift
//  InstrumentTransposer
//
//  Created by Alex Wong on 8/9/18.
//  Copyright © 2018 Kids Can Code. All rights reserved.
//

import UIKit
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: appFont, size: 20)!], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: appFont, size: 20)!], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: appFont, size: hasTraits(view: (self.window?.rootViewController?.view)!, width: .regular, height: .regular) ? 20 : 12)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: appFont, size: hasTraits(view: (self.window?.rootViewController?.view)!, width: .regular, height: .regular) ? 20 : 12)!], for: .selected)
        
        let keychain = KeychainSwift()
        keychain.accessGroup = "H5H633W272.InstrumentTransposer"
        if let pP = keychain.getBool("proPaid") {
            proPaid = pP
        }
        
        UserDefaults.standard.register(defaults: [
            "key1From": "",
            "key1To": "",
            "key2From": "",
            "key2To": "",
            "key3From": "",
            "key3To": "",
            "instrument1From": "",
            "instrument1To": "",
            "instrument2From": "",
            "instrument2To": "",
            "instrument3From": "",
            "instrument3To": ""
        ])
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        IAPManager.shared.stopObserving()
    }


}

