//
//  String.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/14/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import Foundation

extension String {
    var asDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: self)
        return date ?? nil
    }
}
