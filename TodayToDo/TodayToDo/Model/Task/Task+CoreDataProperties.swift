//
//  Task+CoreDataProperties.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/9/22.
//

import Foundation
import CoreData

extension Task {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    @NSManaged public var taskTitle: NSObject?
    @NSManaged public var taskDescription: NSObject?
    @NSManaged public var taskIsDone: NSObject
    @NSManaged public var tasksDate: NSObject?
}

extension Task: Identifiable { }

