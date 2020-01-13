//
//  TestViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit
import Kingfisher

protocol TopHeadlinesDisplayLogic: class {
    func displayTopHeadlines(viewModel: Articles.FetchArticles.ViewModel)
}

class TopHeadlinesViewController: PagingTableViewController, TopHeadlinesDisplayLogic {
    var interactor: TopHeadlinesBusinessLogic?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = TopHeadlinesInteractor()
        let presenter = TopHeadlinesPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchFetchingData()
    }
    
    func launchFetchingData() {
        isLoading = true
        fetchArticles()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.fetchArticles()
        }
    }
    
    // MARK: Fetch Top Headlines
    
    override func fetchArticles(of page: Int = 1, with pageSize: Int = 15) {
        let params = [URLQueryItem(name: "country", value: "us"), URLQueryItem(name: "category", value: "science")]
        let request = Articles.FetchArticles.Request(url: "https://newsapi.org/v2/top-headlines?", params: params, page: page, pageSize: pageSize)
        interactor?.fetchTopHeadlines(request: request)
    }
    
    func displayTopHeadlines(viewModel: Articles.FetchArticles.ViewModel) {
        if let headlines = viewModel.headlines {
            updateArticleList(articleList: headlines, currentPage: viewModel.currentPage, resultsAmount: viewModel.totalResults)
        }
    }
}
