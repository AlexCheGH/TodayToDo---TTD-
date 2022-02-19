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
    private static let compactDateFormat = "MMM d, yyyy"
    private static let preciseDateFormat = "E, d MMM yyyy HH:mm:ss Z"
    
    var compactDate: String {
        dateFormatter.dateFormat = DateManager.compactDateFormat
        return dateFormatter.string(from: date)
    }
    
    var preciseDate: String {
        dateFormatter.dateFormat = DateManager.preciseDateFormat
        return dateFormatter.string(from: date)
    }
    
    func isDateToday(preciseDate: String) -> Bool {
        dateFormatter.dateFormat = DateManager.preciseDateFormat
        let dateToCompare = dateFormatter.date(from: preciseDate)!
        dateFormatter.dateFormat = DateManager.compactDateFormat
        
        return dateFormatter.string(from: dateToCompare) == compactDate
    }
    
    
    func returnDateComponent(from date: Date) -> DateComponents {
        var calendar = Calendar.current
        
        if let timeZone = TimeZone(identifier: TimeZone.current.identifier) {
            calendar.timeZone = timeZone
        }
        guard let stringDate = self.transformToString(date: date) else { return DateComponents() }
        let formatter = DateFormatter()
        formatter.dateFormat = DateManager.preciseDateFormat
        
        let date = formatter.date(from: stringDate)
        guard let date = date else { return DateComponents() }
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let dateComponent = DateComponents(hour: hour,
                                           minute: minute,
                                           second: seconds)
        return dateComponent
    }
    
    func transofrmToDate(string: String?, format: String = preciseDateFormat) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        guard let string = string, let date = formatter.date(from: string) else { return Date() }
        return date
    }
    
    func transformToString(date: Date, format: String = preciseDateFormat) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
