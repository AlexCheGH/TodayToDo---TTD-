//
//  DateManager.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/9/22.
//

import Foundation

class DateManager {
    
    enum DateFormats: String {
        case MMMdyyyyFormat = "MMM d, yyyy"
        case EdMMMyyyyHHmmssZFormat = "E, d MMM yyyy HH:mm:ss Z"
        case HHmmFormat = "HH:mm"
    }
    
    enum DefaultTimes: String {
        case ninePM = "21:00"
    }
    
    private let date = Date()
    private let dateFormatter = DateFormatter()
        
    var currentCompactDate: String { transformToString(date: date, format: .MMMdyyyyFormat)! }
    var currentPreciseDate: String { transformToString(date: date, format: .EdMMMyyyyHHmmssZFormat)! }
    
    var localNotificationTime: Date {
        let dateString = TodayTodoUserDefaults().preferedNotificationTime
        let date = DateManager().transofrmToDate(string: dateString, format: .HHmmFormat)
        
        guard let date = date else {
            let date = DateManager().transofrmToDate(string: DateManager.DefaultTimes.ninePM.rawValue, format: .HHmmFormat)
            return date!
        }
        return date
    }
    
    func isDateToday(preciseDate: String) -> Bool {
        dateFormatter.dateFormat = DateFormats.EdMMMyyyyHHmmssZFormat.rawValue
        let dateToCompare = dateFormatter.date(from: preciseDate)!
        dateFormatter.dateFormat = DateFormats.MMMdyyyyFormat.rawValue
        
        return dateFormatter.string(from: dateToCompare) == currentCompactDate
    }
    
    
    func returnDateComponent(from date: Date, with format: DateFormats = .EdMMMyyyyHHmmssZFormat) -> DateComponents {
        var calendar = Calendar.current
        
        if let timeZone = TimeZone(identifier: TimeZone.current.identifier) {
            calendar.timeZone = timeZone
        }
        guard let stringDate = self.transformToString(date: date) else { return DateComponents() }
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
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
    
    func transofrmToDate(string: String?, format: DateFormats = .EdMMMyyyyHHmmssZFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        guard let string = string else { return nil }
        return formatter.date(from: string)
    }
    
    func transformToString(date: Date, format: DateFormats = .EdMMMyyyyHHmmssZFormat) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
}
