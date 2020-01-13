//
//  PagingTableViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit
import Kingfisher

class PagingTableViewController: UITableViewController {
    
    var articles = [Articles.Article]()
    var isEndOfList = false
    var isLoading = true
    var totalResults: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        registerNibCell(nibName: "LoadingCell", cellId: "loadingCellId")
        registerNibCell(nibName: "ArticleCell", cellId: "articleCellId")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ArticleDetailsViewController
        guard let indexPath = tableView.indexPathForSelectedRow else{fatalError("No indexPath")}
        destinationVC.selectedArticle = articles[indexPath.row]
    }
    
    func registerNibCell(nibName: String, cellId: String){
        let tableViewLoadingCellNib = UINib(nibName: nibName, bundle: nil)
        tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: cellId)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        isLoading = true
        fetchArticles()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return articles.count
        } else if section == 1 && !isEndOfList {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCellId", for: indexPath) as! ArticleCell
            let article = articles[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToArticle", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 195
        } else {
            return 55
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
                let page = self.articles.count / 15 + 1
                print("PAGE", page)
                self.fetchArticles(of: page, with: 15)
            }
        }
    }
    
    func updateArticleList(articleList: [Articles.Article], currentPage: Int, resultsAmount: Int){
        refreshControl?.endRefreshing()
        if isLoading {
            isLoading = false
            updateHeadlines(articleList: articleList, currentPage: currentPage)
        }
        
        if let results = totalResults, totalResults != resultsAmount{
            isLoading = true
            fetchArticles(of: 1, with: (articles.count + abs(resultsAmount - results)) % 100)
        } else {
            totalResults = resultsAmount
        }
    }
    
    func updateHeadlines(articleList: [Articles.Article]?, currentPage: Int) {
        if let headlineList = articleList {
            isEndOfList = headlineList.count < 15 ? true : false
            if currentPage == 1 {
                articles = headlineList
            } else {
                articles.append(contentsOf: headlineList)
            }
            tableView.reloadData()
        }
    }
    
    func fetchArticles(of page: Int = 1, with pageSize: Int = 15){
        
    }

}
