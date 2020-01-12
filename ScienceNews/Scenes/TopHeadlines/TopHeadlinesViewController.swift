//
//  TopHeadlinesViewController.swift
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
import Kingfisher

protocol TopHeadlinesDisplayLogic: class {
    func displayTopHeadlines(viewModel: TopHeadlines.FetchTopHeadlines.ViewModel)
}

class TopHeadlinesViewController: UIViewController, TopHeadlinesDisplayLogic {
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: TopHeadlinesBusinessLogic?
    var router: (NSObjectProtocol & TopHeadlinesRoutingLogic & TopHeadlinesDataPassing)?
    var headlines = [TopHeadlines.Article]()
    var isLoading = false
    var isEndOfList = false
    var totalResults: Int?
    
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
        let router = TopHeadlinesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
  
    // MARK: Routing
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
          let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
          if let router = router, router.responds(to: selector) {
            router.perform(selector, with: segue)
          }
        }
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerNibCell(nibName: "LoadingCell", cellId: "loadingCellId")
        registerNibCell(nibName: "ArticleCell", cellId: "articleCellId")
        launchFetchingData()
    }
    
    func launchFetchingData() {
        isLoading = true
        fetchTopHeadlines()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            self.fetchTopHeadlines()
        }
    }
  
    // MARK: Fetch Top Headlines
  
    func fetchTopHeadlines(of page: Int = 1, with pageSize: Int = 15) {
        let request = TopHeadlines.FetchTopHeadlines.Request(page: page, pageSize: pageSize)
        interactor?.fetchTopHeadlines(request: request)
    }
  
    func displayTopHeadlines(viewModel: TopHeadlines.FetchTopHeadlines.ViewModel) {
        updateHeadlines(articles: viewModel.headlines)
        
        if let results = totalResults, totalResults != viewModel.totalResults{
            isLoading = true
            fetchTopHeadlines(of: 1, with: (headlines.count + abs(viewModel.totalResults - results)) % 100)
        } else {
            totalResults = viewModel.totalResults
        }
    }
    
    func updateHeadlines(articles: [TopHeadlines.Article]?){
        if isLoading{
            isLoading = false
            if let headlineList = articles {
                if headlineList.count < 15 {
                    isEndOfList = true
                }
                headlines.append(contentsOf: headlineList)
                tableView.reloadData()
            }
        }
    }
    
    func registerNibCell(nibName: String, cellId: String){
        let tableViewLoadingCellNib = UINib(nibName: nibName, bundle: nil)
        tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: cellId)
    }
}

extension TopHeadlinesViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return headlines.count
        } else if section == 1 && !isEndOfList {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCellId", for: indexPath) as! ArticleCell
            let article = headlines[indexPath.row]
            cell.title.text = article.title
            cell.articleDescription.text = article.description
            cell.publishDate.text = article.publishDate
            cell.author.text = article.author
            if let url = URL(string: article.imageUrl ?? "") {
                cell.articleImg.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 195
        } else {
            return 55
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height - 55) && !isLoading && !isEndOfList {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                let page = self.headlines.count / 15 + 1
                self.fetchTopHeadlines(of: page)
            }
        }
    }
}
