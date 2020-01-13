//
//  ArticlesWorker.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import Foundation
import RealmSwift

class ArticlesWorker {
    let realm = try! Realm()
    let MY_KEY = "4b2e6714d8dc4d5b941705bea49a6404"
    let AVIATA_KEY = "e65ee0938a2a43ebb15923b48faed18d"

    func fetchArticles(with request: Articles.FetchArticles.Request, completionHandler: @escaping (Articles.FetchArticles.Response?) -> Void) {
        var articleList = ArticleList(articles: [Article](), totalResults: 0)
        
        var components = URLComponents(string: request.url)!
        components.queryItems = [URLQueryItem(name: "pageSize", value: "\(request.pageSize)"), URLQueryItem(name: "page", value: "\(request.page)"), URLQueryItem(name: "apiKey", value: MY_KEY)]
        components.queryItems?.append(contentsOf: request.params)
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let urlRequest = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let dataObject = data else { return }
            do {
                let decoder = JSONDecoder()
                articleList = try decoder.decode(ArticleList.self, from: dataObject)
                let response = Articles.FetchArticles.Response(articles: articleList.articles, totalResults: articleList.totalResults, currentPage: request.page)
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
    
    func createArticlesViewModel(with response: Articles.FetchArticles.Response?) -> Articles.FetchArticles.ViewModel {
        let modifiedArticles = response?.articles?.enumerated().map({ (index, article) -> Article in
            var modifiedArticle = article
            let date = article.publishDate?.asDate.stringForDate(withFormat: "dd.MMMM yyyy")
            modifiedArticle.publishDate = date
            let savedArticle = realm.object(ofType: ArticleObject.self, forPrimaryKey: modifiedArticle.articleUrl)
            let saved = savedArticle != nil ? true : false
            modifiedArticle.saved = saved
            return modifiedArticle
        })
        
        let viewModel = Articles.FetchArticles.ViewModel(headlines: modifiedArticles, totalResults: response?.totalResults ?? 0, currentPage: response?.currentPage ?? 1)
        return viewModel
    }
    
    func loadArticles() -> Results<ArticleObject> {
        return realm.objects(ArticleObject.self)
    }
    
}




extension String {
    var asDate: Date {
        let formatter = DateFormatter()
        formatter.timeZone = currentTimezone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self) ?? Date()
    }
}

extension Date {
    func stringForDate(withFormat dateFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = currentTimezone
        return dateFormatter.string(from: self)
    }
}


let currentTimezone = NSTimeZone(abbreviation: "GMT+6:00") as TimeZone?
