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
    var headlines: [TopHeadlines.Article]?
    
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
    }
  
    // MARK: Fetch Top Headlines
  
    func fetchTopHeadlines() {
        let request = TopHeadlines.FetchTopHeadlines.Request()
        interactor?.fetchTopHeadlines(request: request)
    }
  
    func displayTopHeadlines(viewModel: TopHeadlines.FetchTopHeadlines.ViewModel) {
        headlines = viewModel.headlines
        tableView.reloadData()
    }
}

extension TopHeadlinesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headlineCell", for: indexPath) as! HeadlinesTableViewCell
        if let article = headlines?[indexPath.row] {
            cell.title.text = article.title
            cell.articleDescription.text = article.description
            cell.publishDate.text = article.publishDate
            cell.author.text = article.author
            if let url = URL(string: article.imageUrl ?? "") {
                cell.articleImg.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("DINARA", headlines?.count, "\nIndex", headlines?[indexPath.row].id)
        guard let headlineList = headlines else { return }
        if indexPath.row == headlineList.count - 1 {
            print("RELOADDDDD")
        }
    }
    
}
