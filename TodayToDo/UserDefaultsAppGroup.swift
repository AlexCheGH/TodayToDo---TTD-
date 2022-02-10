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

enum UserDefaultsKeys: String {
    case allTodayTasks = "allTodayTasks"
    case completedTodayTasks = "completedTodayTasks"
    
    case currentWeather = "currentWeather"
}

enum WeatherPreference: Int {
    case fahrenheit = 0
    case celsius = 1
}

//Exists to share the data from the main app to supplementary targets, like widget.
struct TodayTodoUserDefaults {
    private static let userDefaults = UserDefaults(suiteName: UserDefaultsAppGroup.main.rawValue)
    
    //MARK: - Tasks
    var userTodayCompletedTasks: Int {
        let key = UserDefaultsKeys.completedTodayTasks.rawValue
        return TodayTodoUserDefaults.userDefaults?.integer(forKey: key) ?? 0 }
    
    var userAllTodayTasks: Int {
        let key = UserDefaultsKeys.allTodayTasks.rawValue
        return TodayTodoUserDefaults.userDefaults?.integer(forKey: key) ?? 0 }
    
    func updateTaskStat(type: UserDefaultsKeys, value: Int) {
        TodayTodoUserDefaults.userDefaults!.set(value, forKey: type.rawValue)
    }
    
    //MARK: - Weather
    var userWeatherFormatPreference: WeatherPreference {
        let key = UserDefaultsKeys.currentWeather.rawValue
        let value = TodayTodoUserDefaults.userDefaults?.integer(forKey: key) ?? 0
        return WeatherPreference(rawValue: value) ?? .fahrenheit
    }
    ///0 = fahrenheit, 1 = celsius
    func updateWeatherPreference(value: Int) {
        let key = UserDefaultsKeys.currentWeather.rawValue
        TodayTodoUserDefaults.userDefaults?.set(value, forKey: key)
    }
    
}
