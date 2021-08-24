//
//  AppDelegate.swift
//  Find Me
//
//  Created by Developer on 12/2/20.
//

import UIKit
import IQKeyboardManager
import SideMenu

import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared().isEnabled = true
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        //App language setup
        DGLocalization.sharedInstance.startLocalization()
        
        check()
        
        //FCM
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().isAutoInitEnabled = true
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func check(){
        if standard.string(forKey: "userId") != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            let menu = UISideMenuNavigationController(rootViewController: vc!)
            menu.isNavigationBarHidden = true
            
            
          //  let mainNav = UINavigationController(rootViewController: menu)
            let sideMenu = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController
            let rightMenu = UISideMenuNavigationController(rootViewController: sideMenu!)
            rightMenu.menuWidth = (appDelegate.window?.rootViewController?.view.frame.width ?? 375) * 0.75
     
            SideMenuManager.default.menuShadowColor = .black
            SideMenuManager.default.menuShadowRadius = 5
            SideMenuManager.default.menuShadowOpacity = 0.5
            
            
            SideMenuManager.default.menuAnimationFadeStrength = 0.5
            SideMenuManager.default.menuPresentMode = .menuSlideIn
            SideMenuManager.default.menuFadeStatusBar = false
            SideMenuManager.default.menuRightNavigationController = rightMenu
            
            appDelegate.window?.rootViewController = menu
            appDelegate.window?.makeKeyAndVisible()
            
        }else{
            
        }
    }

    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")
        standard.set(fcmToken, forKey: "fcmToken")
     // let dataDict:[String: String] = ["token": fcmToken]
     // NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
       print("Notificaiton Received")
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
       
        print("Present Notification")
    }
   
}

