//
//  Task Manager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/9/22.
//

import Foundation
import UIKit

struct TaskManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var tasks: [Task] = [] //source of truth
    
    var userTasks: [Task] { get { tasks } }
    
    init() {
        self.loadTasks()
    }
    
   private mutating func loadTasks() {
        do { self.tasks = try context.fetch(Task.fetchRequest() ) as [Task] }
        catch { print("An error occured when trying to fetch tasks.") }
    }
    
    mutating func addNewEntry(title: String, description: String?, taskIsDone: Bool = false, preciseDate: String) {
        let task = Task(context: context)
        task.taskTitle = title as NSObject
        task.taskDescription = (description ?? "") as NSObject
        task.taskIsDone = taskIsDone as NSObject
        task.tasksDate = preciseDate as NSObject
        
        saveEntry()
    }
    
    private mutating func saveEntry() {
        do {
            try context.save()
            self.loadTasks()
        }
        catch { print("An error occured when trying to save the task.") }
    }
    
    mutating func removeEntry(for date: String) {
        let objectDate = date as NSObject
        
        //the date is precise, no cases of double values can occure
        let wrappedEntry = tasks.filter{ $0.tasksDate == objectDate }.first
        
        if let entry = wrappedEntry {
            let index = tasks.firstIndex(of: entry)
            context.delete(tasks[index!]) //force unwrap - is it safe?
            saveEntry()
            loadTasks()
        }
    }
    
    func getTask(preciseTaskDate: String) -> Task {
        userTasks.filter{ $0.tasksDate as! String == preciseTaskDate }.first! //should always exist
    }
    
    mutating func createNewTask(title: String, description: String?, taskIsDone: Bool = false, preciseDate: String?) {
        if let preciseDate = preciseDate {
            editEntry(title: title,
                      description: description,
                      preciseDate: preciseDate)
        } else {
            let date = DateManager().preciseDate
            addNewEntry(title: title,
                        description: description,
                        taskIsDone: taskIsDone,
                        preciseDate: date) }
    }
    
    private mutating func editEntry(title: String, description: String?, taskIsDone: Bool = false, preciseDate: String) {
            let task = getTask(preciseTaskDate: preciseDate)
            task.tasksDate = preciseDate as NSObject?
            task.taskIsDone = taskIsDone as NSObject
            task.taskDescription = description as NSObject?
            task.taskTitle = title as NSObject?
            
            saveEntry()
    }    
}
