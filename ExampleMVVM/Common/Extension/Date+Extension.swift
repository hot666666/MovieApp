//
//  Date+Extension.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import Foundation


extension Date {
    var formattedDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }

}
