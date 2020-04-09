//
//  ViewController.swift
//  CheckStatus
//
//  Created by Jovial on 3/2/20.
//  Copyright © 2020 Rajkishore. All rights reserved.
//

import UIKit
import UserNotifications
import Network
class ViewController: UIViewController {
  
     let notificationCenter = UNUserNotificationCenter.current()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
                   
               }
             NetStatus.shared.netStatusChangeHandler = {
                    DispatchQueue.main.async { [unowned self] in
                        self.checkConnection()
                    }
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NetStatus.shared.startMonitoring()
        perform(#selector(checkConnection), with: nil, afterDelay: 3)
    }
    @objc func checkConnection() {
            let result = NetStatus.shared.isConnected ? "Connected" : "Not Connected"
              print(result)
            if result == "Connected" {
            if let currentInterfaceType = NetStatus.shared.interfaceType {
                switch currentInterfaceType {
                case .cellular:
                    callNotification()
                case .wifi:
                    callNotification()
                 //   print("wifi")
                default:
                    callNotification()
                                    }
            }
        }
            else {
                print("not connected")
                callNotification()
               NetStatus.shared.stopMonitoring()
        }
    }
    func callNotification() {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My Catagory Identifier"
        content.title = NetStatus.shared.isConnected ? "Connected" : "Not Connected"
        content.body = "Device is connected with \(NetStatus.shared.availableInterfacesTypes!) network"
        content.badge = 1
        content.sound = .default
        let date1 = Date().addingTimeInterval(5)
        let dateComponent1 = Calendar.current.dateComponents([.year, .month, .hour, .minute, .second], from: date1)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent1, repeats: true)
        let identifier = "Main Identifier"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
           notificationCenter.add(request) { (error) in
            if error == nil {
                print("scheduled !!")
           }
    }
    
}
    
    func applicationDidEnterBackground(_ application: UIApplication) {
          func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                       completionHandler([.alert,.badge,.sound])
             }
       }

}

