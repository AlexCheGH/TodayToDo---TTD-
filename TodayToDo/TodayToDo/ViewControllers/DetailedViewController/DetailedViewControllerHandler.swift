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
        return $isDone.share()
            .map { return $0 ? "✔️" : "🔲" }
            .eraseToAnyPublisher()
    }
    
    var isValidToSave: AnyPublisher <Bool, Never> {
        return Publishers.CombineLatest($title, $description)
            .map { title, description in
                if (title != nil && !title!.isEmpty) || (description != nil && !description!.isEmpty) {
                    return false
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }
    
    var isTitleEmpty: AnyPublisher <Bool, Never> {
        return $title.share()
            .map {
                guard let title = $0 else { return false }
                return title.isEmpty
            }
            .eraseToAnyPublisher()
    }
}
