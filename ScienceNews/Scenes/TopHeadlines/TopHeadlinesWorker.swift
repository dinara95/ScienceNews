//
//  TopHeadlinesWorker.swift
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

class TopHeadlinesWorker {
    
    func fetchTopHeadlines(with request: TopHeadlines.FetchTopHeadlines.Request, completionHandler: @escaping (TopHeadlines.FetchTopHeadlines.Response?) -> Void) {
        var transactionHistoryList = TopHeadlines.ArticleList(articles: [TopHeadlines.Article](), totalResults: 0)
        
        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines?")!
        components.queryItems = [
            URLQueryItem(name: "country", value: "us"), URLQueryItem(name: "category", value: "science"), URLQueryItem(name: "apiKey", value: "e65ee0938a2a43ebb15923b48faed18d"), URLQueryItem(name: "pageSize", value: "\(request.pageSize)"), URLQueryItem(name: "page", value: "\(request.page)")
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let urlRequest = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let dataObject = data else { return }
            do {
                let decoder = JSONDecoder()
                transactionHistoryList = try decoder.decode(TopHeadlines.ArticleList.self, from: dataObject)
                let response = TopHeadlines.FetchTopHeadlines.Response(articles: transactionHistoryList.articles, totalResults: transactionHistoryList.totalResults, currentPage: request.page)
                DispatchQueue.main.async {
                    completionHandler(response)
                }
            } catch let error {
                print("Error decoding TopHeadlines json \(error)")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }.resume()
    }
}
