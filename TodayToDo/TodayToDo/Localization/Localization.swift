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
    }
    
    struct Widget {
        static let widgetTitle = NSLocalizedString("todayToDoWidget", comment: "")
        static let widgetDescription = NSLocalizedString("widgetDescription", comment: "")
    }
    
}
