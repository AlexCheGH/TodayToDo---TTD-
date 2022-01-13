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
    
    private var tasks: [Task] = []
    
    var userTasks: [Task] { get { tasks } }
    
    init() {
        self.loadTasks()
    }
    
    mutating func loadTasks() {
        do { self.tasks = try context.fetch(Task.fetchRequest() ) as [Task] }
        catch { print("An error occured when trying to fetch tasks.") }
    }
    
    mutating func addNewEntry(title: String, description: String?, taskIsDone: Bool = false) {
        let task = Task(context: context)
        task.taskTitle = title as NSObject
        task.taskDescription = (description ?? "") as NSObject
        task.taskIsDone = taskIsDone as NSObject
        task.tasksDate = DateManager().preciseDate as NSObject
        
        saveEntry()
    }
    
    private mutating func saveEntry() {
        do {
           try context.save()
            self.loadTasks()
        }
        catch { print("An error occured when trying to save the task.") }
    }
    
        //для удаления использовать точную дату создания ентри. Придется передевать ее в тейблвью селл
    
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
    
    
    
    mutating func createTestTasks() {
        for index in 1...4 {
            addNewEntry(title: "Title #\(index)", description: "A description for title #\(index)")
        }
        loadTasks()
    }
    
}
