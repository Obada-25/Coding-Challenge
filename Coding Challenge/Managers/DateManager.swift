//
//  DateManager.swift
//  Coding Challenge
//
//  Created by obada darkznly on 01.04.22.
//

import Foundation


class DateManager {
    
    // MARK: Properties
    private let isoDateFormatter = ISO8601DateFormatter()
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df
    }
    
    // Shared instance
    static let shared = DateManager()
    
    // MARK: Methods
    func getDate(from dateString: String) -> String? {
        if let date = isoDateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
