//
//  FeedDateFormatter.swift
//  Cars
//
//  Created by Oleg Samoylov on 02.04.2022.
//

import Foundation

final class FeedDateFormatter: DateFormatter {

    override func string(from date: Date) -> String {
        let timeFormat: String
        var dateFormat = "d MMMM"

        let dateYear = Calendar.current.component(.year, from: date)
        let nowYear = Calendar.current.component(.year, from: .init())

        if dateYear != nowYear {
            dateFormat += " y"
        }

        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: .current)
        if formatter?.contains("a") ?? false {
            timeFormat = "h:mm a"
        } else {
            timeFormat = "H:mm"
        }

        self.dateFormat = "\(dateFormat), \(timeFormat)"
        return super.string(from: date)
    }
}
