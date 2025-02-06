//
//  ViewController.swift
//  Test2
//
//  Created by Felipe Roque on 05/02/25.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController, CleverTapInboxViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestNotificationPermission()

        let profile: Dictionary<String, Any> = [
            "Identity": 9820301,
            "Name": "Felipe",
            "Email": "clevertapfeliperoque@gmail.com"
        ]

        CleverTap.sharedInstance()?.profilePush(profile)
        

        CleverTap.sharedInstance()?.initializeInbox(callback: ({ [weak self] (success) in
                let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
            self?.sendLocalNotification()
         }))

        
    }
    
    @IBAction func productCommit() {
        
        
        
        let props = [
            "Product ID": 1,
            "Product Image": "https://d35fo82fjcw0y8.cloudfront.net/2018/07/26020307/customer-success-clevertap.jpg",
            "Product Name": "CleverTap"
        ] as [String : Any]

        CleverTap.sharedInstance()?.recordEvent("Product viewed", withProps: props)
        

    }
    
    func requestNotificationPermission() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    print("Permission granted")
                } else {
                    print("Permission denied")
                }
            }
        }
    
    func sendLocalNotification() {
        // config the style of App Inbox Controller
            let style = CleverTapInboxStyleConfig.init()
            style.title = "App Inbox"
        style.backgroundColor = UIColor.blue
            style.messageTags = ["tag1", "tag2"]
        style.navigationBarTintColor = UIColor.blue
        style.navigationTintColor = UIColor.blue
        style.tabUnSelectedTextColor = UIColor.blue
        style.tabSelectedTextColor = UIColor.blue
        style.tabSelectedBgColor = UIColor.blue
            style.firstTabTitle = "My First Tab"
            
            if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
                let navigationController = UINavigationController.init(rootViewController: inboxController)
                self.present(navigationController, animated: true, completion: nil)
          }
      }
}

