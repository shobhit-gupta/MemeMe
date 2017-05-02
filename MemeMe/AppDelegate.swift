//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 21/02/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memeItems = [MemeItem]()
    let numMemes = Int.random(lower: Default.Random.Meme.Download.Min,
                              upper: Default.Random.Meme.Download.Max)
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ArtKit.setupAppearance()
        generateRandomMemes(stop: numMemes)
        return true
    }
    
    
    func generateRandomMemes(stop: Int) {
        if stop <= 0 {
            return
        }
        Meme.random() { (meme) in
            if let meme = meme {
                self.memeItems.append(MemeItem(with: meme))
                // fix: Send this notification from here instead of the didSet observer in memeItems property.
                // Doing otherwise crashes table view when deleting a row.
                let notification = Notification(name: Notification.Name(rawValue: Default.Notification.MemesModified.rawValue),
                                                object: nil,
                                                userInfo: nil)
                NotificationCenter.default.post(notification)
                self.generateRandomMemes(stop: stop - 1)
            }
        }
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
    }


}

