//
//  TestViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit

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
        fetchArticles()
//        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
//            self.fetchArticles()
//        }
    }
    
    // MARK: Fetch Top Headlines
    
    override func fetchArticles(of page: Int = 1, with pageSize: Int = 15) {
        let request = Articles.FetchArticles.Request(url: API.TopHeadlines.url, params: API.TopHeadlines.params, page: page, pageSize: pageSize)
        interactor?.fetchTopHeadlines(request: request)
    }
    
    func displayTopHeadlines(viewModel: Articles.FetchArticles.ViewModel) {
        updateArticleList(articleList: viewModel.headlines ?? [], currentPage: viewModel.currentPage, resultsAmount: viewModel.totalResults)
    }
}
