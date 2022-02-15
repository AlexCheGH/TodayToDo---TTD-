//
//  Localization.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/23/22.
//

import Foundation

struct Localization {
    
    struct Delete {
        static let deleteTask = NSLocalizedString("delete_task", comment: "")
        static let deleteTaskConfirmation = NSLocalizedString("delete_task_confirmation", comment: "")
    }
    
    struct UserChoice {
        static let yes = NSLocalizedString("yes", comment: "")
        static let no = NSLocalizedString("no", comment: "")
        static let cancel = NSLocalizedString("cancel", comment: "")
    }
    
    struct Label {
        static let save = NSLocalizedString("save", comment: "")
        static let status = NSLocalizedString("status", comment: "")
        static let done = NSLocalizedString("done", comment: "")
    }
    
    struct Widget {
        static let widgetTitle = NSLocalizedString("todayToDoWidget", comment: "")
        static let widgetDescription = NSLocalizedString("widgetDescription", comment: "")
    }
    
    struct Settings {
        static let settingsTitle = NSLocalizedString("settings", comment: "")
        static let temperatureFormat = NSLocalizedString("temperature_format", comment: "")
        static let celsius = NSLocalizedString("temp_celc", comment: "")
        static let fahrenheit = NSLocalizedString("temp_fahr", comment: "")
        static let celsiusCompact = NSLocalizedString("temp_celc_compact", comment: "")
        static let fahrenheitCompact = NSLocalizedString("temp_fahr_compact", comment: "")
        static let pushMessages = NSLocalizedString("push_messages", comment: "")
        static let on = NSLocalizedString("on", comment: "")
        static let off = NSLocalizedString("off", comment: "")
        static let selectTime = NSLocalizedString("select_time", comment: "")
    }
    
}
