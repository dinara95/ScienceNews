//
//  String.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/14/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import Foundation

extension String {
    var asDate: Date {
        let formatter = DateFormatter()
        formatter.timeZone = currentTimezone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self) ?? Date()
    }
}
