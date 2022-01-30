//
//  UserDefaultsAppGroup.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/30/22.
//

import Foundation

public enum UserDefaultsAppGroup: String {
    case main = "group.com.alexChekushkin.TodayToDo"
}

enum TasksDataDefaults: String {
    case allTodayTasks = "allTodayTasks"
    case completedTodayTasks = "completedTodayTasks"
}


//Exists to share the data from the main app to supplementary targets, like widget.
struct TodayTodoUserDefaults {
    private static let userDefaults = UserDefaults(suiteName: UserDefaultsAppGroup.main.rawValue)
    
    var userTodayCompletedTasks: Int { TodayTodoUserDefaults.userDefaults?.integer(forKey: TasksDataDefaults.completedTodayTasks.rawValue) ?? 0 }
    var userAllTodayTasks: Int { TodayTodoUserDefaults.userDefaults?.integer(forKey: TasksDataDefaults.allTodayTasks.rawValue) ?? 0 }
    
    func updateTaskStat(type: TasksDataDefaults, value: Int) {
        TodayTodoUserDefaults.userDefaults!.set(value, forKey: type.rawValue)
    }
}
