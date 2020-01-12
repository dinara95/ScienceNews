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
        fetchTopHeadlines()
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingCell")
        let articleCellNib = UINib(nibName: "ArticleCell", bundle: nil)
        self.tableView.register(articleCellNib, forCellReuseIdentifier: "articleCellId")
    }
  
    // MARK: Fetch Top Headlines
  
    func fetchTopHeadlines() {
        let page = headlines.count / 15 + 1
        let request = TopHeadlines.FetchTopHeadlines.Request(page: page)
        interactor?.fetchTopHeadlines(request: request)
    }
  
    func displayTopHeadlines(viewModel: TopHeadlines.FetchTopHeadlines.ViewModel) {
        isLoading = false
        
        if let headlineList = viewModel.headlines {
            if headlineList.count < 15 {
                isEndOfList = true
                
            }
            headlines.append(contentsOf: headlineList)
            tableView.reloadData()
        }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 194
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
                self.fetchTopHeadlines()
            }
        }
    }
}
