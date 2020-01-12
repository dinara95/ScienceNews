//
//  TopHeadlinesModels.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/11/20.
//  Copyright (c) 2020 Dinara Shadyarova. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum TopHeadlines {
  // MARK: Use cases
  
    enum FetchTopHeadlines {
        struct Request {
            var page: Int
        }
        struct Response {
            var articles: [Article]?
        }
        struct ViewModel {
            var headlines: [Article]?
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
        
        private enum CodingKeys: String, CodingKey {
            case title
            case author
            case description
            case imageUrl = "urlToImage"
            case publishDate = "publishedAt"
            case content
        }
    }
    
    struct ArticleList: Codable {
        var articles: [Article]?
    }
    
    
}
