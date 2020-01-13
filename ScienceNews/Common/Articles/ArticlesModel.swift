//
//  Model.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit

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
    
    struct Article: Codable {
        var title: String?
        var author: String?
        var description: String?
        var imageUrl: String?
        var publishDate: String?
        var content: String?
        var id: Int?
        var articleUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case title
            case author
            case description
            case imageUrl = "urlToImage"
            case publishDate = "publishedAt"
            case content
            case articleUrl = "url"
        }
    }
    
    struct ArticleList: Codable {
        var articles: [Article]?
        var totalResults: Int
    }
    
    
}

