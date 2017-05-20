//
//  AppDelegate.swift
//  MusicFinder
//
//  Created by TRAING Serey on 25/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import SWRevealViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SWRevealViewControllerDelegate, SPTAudioStreamingDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var viewController: SWRevealViewController?
    
    var auth: SPTAuth?
    var player: SPTAudioStreamingController?
    var authViewController: UIViewController
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        let leftMenuVC = LeftMenuVC(nibName: "LeftMenuVC", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.auth = SPTAuth.defaultInstance()
        self.player = SPTAudioStreamingController.sharedInstance()
        self.auth?.clientID = "fdad9d96ab20485e954addb639fd222a"
        self.auth?.redirectURL = NSURL(string: "musicfinder-auth://callback") as! URL
        self.auth?.sessionUserDefaultsKey = "current session"
        self.auth?.requestedScopes = [SPTAuthStreamingScope]
        
        self.player?.delegate = self
        
        
        
        //RevealVC
        
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        let leftMenuNavigationController = UINavigationController(rootViewController: leftMenuVC)
        let revealVC = SWRevealViewController(rearViewController: leftMenuNavigationController, frontViewController: homeNavigationController)
       
        revealVC?.delegate = self;
        self.viewController = revealVC;
        self.window!.rootViewController = self.viewController
        self.window!.makeKeyAndVisible()
        
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
    }

    func startAuthenticationFlow() {
        if (self.auth?.session.isValid())! {
            self.player?.login(withAccessToken: self.auth?.session.accessToken)
        } else {
            let authURL = self.auth?.spotifyWebAuthenticationURL() as! NSURL
            self.authViewController = SFSafariViewController(url: authURL as URL)
            self.window?.rootViewController?.present(self.authViewController, animated: true, completion: nil)
            
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (self.auth?.canHandle(url))! {
            self.authViewController.presentingViewController?.dismiss(animated: true, completion: nil)
            //self.authViewController = nil
            self.auth?.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error: NSError, session: SPTSession) in
                if session {
                    self.player?.login(withAccessToken: self.auth?.session.accessToken)
                }
            } as! SPTAuthCallback)
            return true
        }
        return false
    }

}

