//
//  Date+alldays.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 02/08/2021.
//  Copyright © 2021 Ephod. All rights reserved.
//

import Foundation

extension Date
{
    mutating func addDays(n: Int)
    {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }

    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
            Calendar.current.dateComponents([.year,.month], from: self))!
    }

    func getAllDays() -> [Date]
    {
        var days = [Date]()

        let calendar = Calendar.current

        let range = calendar.range(of: .day, in: .month, for: self)!

        var day = firstDayOfTheMonth()

        for _ in 1...range.count
        {
            days.append(day)
            day.addDays(n: 1)
        }

        return days
    }
}


extension Date {
    func timeAgoDisplay() -> String {

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
