//
//  Date.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/14/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import Foundation

extension Date {
    func stringForDate(withFormat dateFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = currentTimezone
        return dateFormatter.string(from: self)
    }
}
