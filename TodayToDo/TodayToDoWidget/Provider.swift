//
//  Provider.swift
//  TodayToDoWidgetExtension
//
//  Created by Alex Chekushkin on 1/30/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> TaskEntry {
        WidgetTaskDataProvider().dummyEnrty
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TaskEntry) -> ()) {
        completion(WidgetTaskDataProvider().dummyEnrty)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<TaskEntry>) -> ()) {
        var entries: [TaskEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            let dataProvider = WidgetTaskDataProvider()
            
            let entry = TaskEntry(date: entryDate,
                                  totalTasks: dataProvider.allTodayTasks,
                                  tasksCompleted: dataProvider.todayCompletedTasks,
                                  todayDate: dataProvider.todayDate,
                                  configuration: ConfigurationIntent())
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct TaskEntry: TimelineEntry {
    var date: Date
    
    let totalTasks: Int
    let tasksCompleted: Int
    let todayDate: String
    let configuration: ConfigurationIntent
}
