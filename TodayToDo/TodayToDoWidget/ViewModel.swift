//
//  ViewModel.swift
//  TodayToDoWidgetExtension
//
//  Created by Alex Chekushkin on 1/30/22.
//

import Foundation

struct WidgetTaskDataProvider {
    
    let dummyEnrty = TaskEntry(date: Date(), totalTasks: 10, tasksCompleted: 6, todayDate: "March, 21, 2022", configuration: ConfigurationIntent())
 
    var allTodayTasks = TodayTodoUserDefaults().userAllTodayTasks
    var todayCompletedTasks = TodayTodoUserDefaults().userTodayCompletedTasks
    
    var todayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: Date())
    }
}
