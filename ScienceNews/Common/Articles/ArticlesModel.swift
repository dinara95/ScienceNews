//
//  Model.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit
import RealmSwift

enum Articles {
    // MARK: Use cases
    
    enum FetchArticles {
        struct Request {
            var url: String
            var params: [URLQueryItem]
            var page: Int
            var pageSize: Int
        }
        struct Response {
            var articles: [Article]?
            var totalResults: Int?
            var currentPage: Int?
        }
        struct ViewModel {
            var headlines: [Article]?
            var totalResults: Int
            var currentPage: Int
        }
    }


}


    struct Article: Codable {
        var title: String?
        var author: String?
        var articleDescription: String?
        var imageUrl: String?
        var publishDate: String?
        var content: String?
        var articleUrl: String?
        var saved: Bool?

        private enum CodingKeys: String, CodingKey {
            case title
            case author
            case articleDescription = "description"
            case imageUrl = "urlToImage"
            case publishDate = "publishedAt"
            case content
            case articleUrl = "url"
        }
    }


struct ArticleList: Codable {
    var articles: [Article]?
    var totalResults: Int?
}

class ArticleObject: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var articleDescription: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var publishDate: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var articleUrl: String = ""
    @objc dynamic var saved: Bool = false
    
    override static func primaryKey() -> String? {
        return "articleUrl"
    }
//
//    private enum CodingKeys: String, CodingKey {
//        case title
//        case author
//        case articleDescription = "description"
//        case imageUrl = "urlToImage"
//        case publishDate = "publishedAt"
//        case content
//        case articleUrl = "url"
//    }
}

