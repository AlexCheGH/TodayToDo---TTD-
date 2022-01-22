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
    
    
    private mutating func saveEntry() {
        do {
            try context.save()
            self.loadTasks()
        }
        catch { print("An error occured when trying to save the task.") }
    }
    
    /// Gets a task to populate UIView/UICell
    func getTask(preciseTaskDate: String) -> Task {
        guard let task = userTasks.filter({ $0.tasksDate as! String == preciseTaskDate }).first else {
            
            let task = Task(context: context)
            return task
        }
        
        return task
    } //should always exist
    
    /// Function decides whether to edit or create new task. If "preciseDate" is nil -> creates new task
    mutating func createNewTask(title: String, description: String?, taskIsDone: Bool = false, preciseDate: String?) {
        if let preciseDate = preciseDate {
            editEntry(title: title,
                      description: description,
                      taskIsDone: taskIsDone,
                      preciseDate: preciseDate)
        } else {
            let date = DateManager().preciseDate
            addNewEntry(title: title,
                        description: description,
                        taskIsDone: taskIsDone,
                        preciseDate: date) }
    }
    
    // Creates a fresh task
    private mutating func addNewEntry(title: String, description: String?, taskIsDone: Bool = false, preciseDate: String) {
        let task = Task(context: context)
        task.taskTitle = title as NSObject
        task.taskDescription = (description ?? "") as NSObject
        task.taskIsDone = taskIsDone as NSObject
        task.tasksDate = preciseDate as NSObject
        
        saveEntry()
    }
    
    // Edits an existing task
    private mutating func editEntry(title: String, description: String?, taskIsDone: Bool = false, preciseDate: String) {
        let task = getTask(preciseTaskDate: preciseDate)
        task.tasksDate = preciseDate as NSObject
        task.taskIsDone = taskIsDone as NSObject
        task.taskDescription = (description ?? "") as NSObject
        task.taskTitle = title as NSObject
        
        validateTask(task: task) ? saveEntry() : Void()
    }
    
    /// Removes task for the specific date or index
    mutating func removeEntry(for preciseDate: String? = nil, index: Int? = nil) {
        
        if let index = index {
            context.delete(tasks[index])
        }
        if let preciseDate = preciseDate {
            let task = getTask(preciseTaskDate: preciseDate)
            let index = tasks.firstIndex(of: task)
            context.delete(tasks[index!])
        }
        saveEntry()
    }
    
    // Validates whether a task needs to be created or not. If task title is empty it wont be created. If a task lack title, but has a description it'll be named as the description first symbols
    private func validateTask(task: Task) -> Bool {
        let title = task.taskTitle as! String
        let description = task.taskDescription as! String
        
        let titleIsEmpty = title.filter{ $0 != " " }.isEmpty
        let descriptionIsEmpty = description.filter{ $0 != " " }.isEmpty
        
        //if title is empty, but description is not, the tittle will be saved as the initial 10 characters of the description
        if titleIsEmpty && !descriptionIsEmpty {
            let text = String(description.prefix(10) + "...")
            task.taskTitle = text as NSObject
            return true
        } else if titleIsEmpty && descriptionIsEmpty {
            return false
        }
        return true
    }
}
