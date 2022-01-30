//
//  TodayToDoWidget.swift
//  TodayToDoWidget
//
//  Created by Alex Chekushkin on 1/28/22.
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

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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

struct TodayToDoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.todayDate)
            Text("All tasks: \(entry.totalTasks)")
            Text("Completed: \(entry.tasksCompleted)")
        }
    }
}

@main
struct TodayToDoWidget: Widget {
    let kind: String = "TodayToDoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TodayToDoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Localization.Widget.widgetTitle)
        .description(Localization.Widget.widgetDescription)
    }
}

struct TodayToDoWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodayToDoWidgetEntryView(entry: TaskEntry(date: Date(), totalTasks: 5, tasksCompleted: 3, todayDate: "March, 21, 2022", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
