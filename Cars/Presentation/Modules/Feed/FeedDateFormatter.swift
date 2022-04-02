//
//  FeedDateFormatter.swift
//  Cars
//
//  Created by Oleg Samoylov on 02.04.2022.
//

import Foundation

final class FeedDateFormatter: DateFormatter {

    override func string(from date: Date) -> String {
        let dateFormat: String
        let timeFormat: String

        if isCurrentYear(date) {
            dateFormat = "d MMMM"
        } else {
            dateFormat = "d MMMM y"
        }

        if isSetTo24Hours {
            timeFormat = "H:mm"
        } else {
            timeFormat = "h:mm a"
        }

        self.dateFormat = "\(dateFormat), \(timeFormat)"
        return super.string(from: date)
    }
}

// MARK: - Private

private extension FeedDateFormatter {

    var isSetTo24Hours: Bool {
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: .current)
        return formatter?.contains("a") != true
    }

    func isCurrentYear(_ date: Date) -> Bool {
        let dateYear = Calendar.current.component(.year, from: date)
        let nowYear = Calendar.current.component(.year, from: .init())

        return dateYear == nowYear
    }
}
