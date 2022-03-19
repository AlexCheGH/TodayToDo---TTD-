//
//  TodayToDoWidget.swift
//  TodayToDoWidget
//
//  Created by Alex Chekushkin on 1/28/22.
//

import WidgetKit
import SwiftUI
import Intents

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
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
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
