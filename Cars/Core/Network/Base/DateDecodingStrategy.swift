//
//  DateDecodingStrategy.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import Foundation

struct DateDecodingStrategy {

    func convert(using decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let date: Date?

        if let string = try? container.decode(String.self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YYYY HH:mm"
            date = formatter.date(from: string)
        } else if let number = try? container.decode(Double.self) {
            date = Date(timeIntervalSince1970: number)
        } else {
            date = nil
        }

        if let date = date {
            return date
        } else {
            throw RequestError.decode
        }
    }
}
