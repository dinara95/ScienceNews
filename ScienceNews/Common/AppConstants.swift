//
//  AppConstants.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/14/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import Foundation


struct API {
    struct TopHeadlines {
        static let url = "https://newsapi.org/v2/top-headlines?"
        static let params = [URLQueryItem(name: "country", value: "us"), URLQueryItem(name: "category", value: "science")]
    }
    struct Everything {
        static let url = "https://newsapi.org/v2/everything?"
        static let params = [URLQueryItem(name: "q", value: "science"), URLQueryItem(name: "language", value: "en")]
    }
    static let KEY = "e65ee0938a2a43ebb15923b48faed18d"
    static let MY_KEY = "4b2e6714d8dc4d5b941705bea49a6404"
}


let currentTimezone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
