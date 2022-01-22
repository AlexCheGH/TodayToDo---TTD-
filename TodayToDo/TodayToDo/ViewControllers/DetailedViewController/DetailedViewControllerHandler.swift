//
//  DetailedViewControllerHandler.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/22/22.
//

import Foundation
import Combine


protocol DetailedCardViewProtocol {
    func saveTask(taskTitle: String?, taskDescription: String?, taskIsDone: Bool, taskPresiceDate: String?)
    func deleteTask(preciseDate: String)
}

class DetailedViewControllerHandler: ObservableObject {
    @Published var title: String?
    @Published var description: String?
    @Published var isDone: Bool = false
    @Published var preciseDate: String?
    @Published var isNewTask: Bool = true
    
    var statusImage: AnyPublisher <String, Never> {
        return Publishers.CombineLatest($isDone, $description)
            .map{ isDone, _ in
                return isDone ? "✔️" : "🔲"
            }
            .eraseToAnyPublisher()
    }
    
    var isValidToSave: AnyPublisher <Bool, Never> {
        return Publishers.CombineLatest($title, $description)
            .map{ title, _ in
                guard let title = title else { return true }
                return (title.isEmpty && title == "")
            }
            .eraseToAnyPublisher()
    }
    
    var isTitleEmpty: AnyPublisher <Bool, Never> {
        return Publishers.CombineLatest($title, $description)
            .map{ title, _ in
                //false prevents title being highlighted on the initial open
                guard let title = title else { return false }
                return title.isEmpty
            }
            .eraseToAnyPublisher()
    }
}
