//
//  AppDelegate.swift
//  Instagram
//
//  Created by 于武 on 2017/12/22.
//  Copyright © 2017年 于武. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        AVOSCloud.setApplicationId("XE5Vk4nU7W4i034brWAPcNBF-gzGzoHsz", clientKey: "2PnHPN7zEDIzmdGr25j7xMkx")
        //跟踪统计应用打开情况
        AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        login()
        
        
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

    func login()  {
        //获取储存在本地的用户名
        let username: String? = UserDefaults.standard.string(forKey: "username")
        //如果之前成功登陆过
        if username != nil {
           
let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let myTabBar = storyboard.instantiateViewController(withIdentifier:"TabBar") as! UITabBarController
 window?.rootViewController = myTabBar
            //互相关注代码
//    AVUser.current()?.follow("5a4dca1fd50eee00718ef2dc", andCallback: { (success:Bool?, error:Error?) in
//
//                if success! {
//
//                    print("关注成功")
//                }else {
//                    print("关注失败")
//
//                }
//            })
            
        }
    }
}

