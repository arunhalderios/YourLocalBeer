//
//  AppDelegate.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import FacebookLogin
import GoogleSignIn
import GooglePlaces
import GoogleMaps
import FBSDKLoginKit
import FBSDKCoreKit

//let kClientKey = "AIzaSyC7hQ6hViSKujx4fB4OnLH451cobAc-VLI"
//let kClientKey = "AIzaSyDvFw9p8CbHpr6qvpHc3kG-_RTWSWfMLJk"
let kClientKey = "AIzaSyBVYEQtid4BGbKWbshh7r5AVsr755EcSd4"//"AIzaSyDEJSR-LC61-UDbRUcvG0YOohnDIP1bbzo"//"AIzaSyC7hQ6hViSKujx4fB4OnLH451cobAc-VLI"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance().clientID = "757755460185-02kimd8p88gnpgscrjh9i15vghu886r1.apps.googleusercontent.com"

        GMSPlacesClient.provideAPIKey(kClientKey)
        GMSServices.provideAPIKey(kClientKey)
        
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
       // return true
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        let value: String = url.absoluteString as String
        print("URL :\(value)")

        if value.range(of:"facebook") != nil {
            return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: nil)
        }else{
            return GIDSignIn.sharedInstance().handle(url)
        }
    }


}

