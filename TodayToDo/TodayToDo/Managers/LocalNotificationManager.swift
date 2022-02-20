//
//  LocalNotificationManager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 2/16/22.
//

import Foundation
import NotificationCenter



class LocalNotificationManager {
    
    enum NotificationType: String {
        case dailyStatistics = "dailyStatistics"
        case taskReminder = "taskReminder"
    }
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: [.alert, .sound, .badge])
        
        self.userNotificationCenter.requestAuthorization(options: authOptions) { _, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func sendNotification(notificationType: NotificationType, for dateComponent: DateComponents, task: Task? = nil) {
        let notificationContent = UNMutableNotificationContent()
        
        var notificationRepeats = false
        var identifier = ""
                
        switch notificationType {
        case .dailyStatistics:
            let userDefaults = TodayTodoUserDefaults()
            let completedTasks = String(userDefaults.userTodayCompletedTasks)
            let allTasks = String(userDefaults.userAllTodayTasks)
            
            let notificationDescription = String(format: Localization.LocalNotifications.tasksDoneDescription, completedTasks, allTasks)
            
            notificationContent.title = Localization.LocalNotifications.tasksDoneTitle
            notificationContent.body = notificationDescription
            
            notificationRepeats = true
            identifier = notificationType.rawValue
            
        case .taskReminder:
            print("todo")
        }
        
        if let url = Bundle.main.url(forResource: "checklist", withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "checklist",
                                                              url: url,
                                                              options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent,
                                                    repeats: notificationRepeats)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    
    //notificationType serves as an ID for .dailyStatics case
    func updateNotification(notificationType: NotificationType, task: Task? = nil) {
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [notificationType.rawValue])
        center.removePendingNotificationRequests(withIdentifiers: [notificationType.rawValue])
        
        
    }
    
}
