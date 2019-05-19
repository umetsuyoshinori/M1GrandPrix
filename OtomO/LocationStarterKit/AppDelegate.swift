//
//  AppDelegate.swift
//  LocationStarterKit
//
//  Created by Takamitsu Mizutori on 2016/08/12.
//  Copyright © 2016年 Goldrush Computing Inc. All rights reserved.
//

import UIKit
import UserNotifications
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        LocationService.sharedInstance.startUpdatingLocation()
        
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
    
    
    
    /*----------------------------------------------------------------------------------*/
    //ApDelegate.swiftの起動時に呼ばれる関数
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // current() メソッドを使用してシングルトンオブジェクトを取得
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        //テストの為、現在のノーティフケーションを削除します
        //center.removeAllPendingNotificationRequests();

        // 通知の使用許可をリクエスト
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in if granted {print("通知許可")}
        }
        
        
        return true
    }
    
    //通知表示のタイミングで呼ばれる関数
    //（アプリがアクティブ、非アクテイブ、アプリ未起動,バックグラウンドでも呼ばれる）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])//音とポップでお知らせ
    }
//
    //通知タップ後に呼ばれる関数(↑の関数が呼ばれた後に呼ばれる)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //再生ビューに飛び、再生を開始
        //windowを生成
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //Storyboardを指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Viewcontrollerを指定
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "Play")
        //rootViewControllerに入れる
        self.window?.rootViewController = initialViewController
        //表示
        self.window?.makeKeyAndVisible()
        
        
        
        completionHandler()
    }
}



