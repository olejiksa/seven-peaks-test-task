//
//  FeedDateFormatter.swift
//  Cars
//
//  Created by Oleg Samoylov on 02.04.2022.
//

import Foundation

final class FeedDateFormatter: DateFormatter {

    private let currentDate: Date
    private let currentLocale: Locale

    init(currentDate: Date = .init(),
         currentLocale: Locale = .current) {
        self.currentDate = currentDate
        self.currentLocale = currentLocale

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: currentLocale)
        return formatter?.contains("a") != true
    }

    func isCurrentYear(_ date: Date) -> Bool {
        let dateYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: currentDate)
        return dateYear == currentYear
    }
}
