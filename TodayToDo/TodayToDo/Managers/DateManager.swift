//
//  DateManager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/9/22.
//

import Foundation

class DateManager {
    
    private let date = Date()
    private let dateFormatter = DateFormatter()
    private let compactDateFormat = "MMM d, yyyy"
    private let preciseDateFormat = "E, d MMM yyyy HH:mm:ss Z"
    
    var compactDate: String {
        dateFormatter.dateFormat = compactDateFormat
        return dateFormatter.string(from: date)
    }
    
    var preciseDate: String {
        dateFormatter.dateFormat = preciseDateFormat
        return dateFormatter.string(from: date)
    }
}
