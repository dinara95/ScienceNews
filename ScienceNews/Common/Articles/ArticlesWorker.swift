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

    func fetchArticles(with request: Articles.FetchArticles.Request, completionHandler: @escaping (Articles.FetchArticles.Response?) -> Void) {
        var articleList = ArticleList(articles: [Article](), totalResults: 0)
        
        var components = URLComponents(string: request.url)!
        components.queryItems = [URLQueryItem(name: "pageSize", value: "\(request.pageSize)"), URLQueryItem(name: "page", value: "\(request.page)"), URLQueryItem(name: "apiKey", value: API.KEY)]
        components.queryItems?.append(contentsOf: request.params)
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let urlRequest = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                guard let dataObject = data else { throw FetchingError.networkError("") }
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
            let date = article.publishDate?.asDate?.stringForDate(withFormat: "dd.MMMM yyyy")
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









