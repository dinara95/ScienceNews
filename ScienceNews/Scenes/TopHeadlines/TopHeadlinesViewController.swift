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
    func displayTopHeadlines(viewModel: TopHeadlines.FetchTopHeadlines.ViewModel)
}

class TopHeadlinesViewController: PagingTableViewController, TopHeadlinesDisplayLogic {
    
    
    var interactor: TopHeadlinesBusinessLogic?
    var headlines = [TopHeadlines.Article]()
    
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
        let request = TopHeadlines.FetchTopHeadlines.Request(page: page, pageSize: pageSize)
        interactor?.fetchTopHeadlines(request: request)
    }
    
    func displayTopHeadlines(viewModel: TopHeadlines.FetchTopHeadlines.ViewModel) {
        if let headlines = viewModel.headlines {
            updateArticleList(articleList: headlines, currentPage: viewModel.currentPage, resultsAmount: viewModel.totalResults)
        }
    }
}
