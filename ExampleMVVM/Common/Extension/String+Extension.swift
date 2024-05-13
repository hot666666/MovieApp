//
//  String+Extension.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        return dateFormatter.date(from: self)
    }
    
    func trimmed(to length: Int = 200) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            return "\(self[..<index])..."
        } else {
            return self
        }
    }
}
