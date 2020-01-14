//
//  PagingTableViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class PagingTableViewController: UITableViewController {
    let realm = try! Realm()
    let container = try! Container()
    var articles = [Article]()
    var isEndOfList = false
    var isLoading = true
    var totalResults: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addTapped))
        refreshControl?.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        registerNibCell(nibName: "LoadingCell", cellId: "loadingCellId")
        registerNibCell(nibName: "ArticleCell", cellId: "articleCellId")
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: "goToSavedArticles", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToArticle" {
            let destinationVC = segue.destination as! ArticleDetailsViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("No indexPath") }
            destinationVC.selectedArticle = articles[indexPath.row]
        }
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
            var article = articles[indexPath.row]
            let savedArticle = realm.object(ofType: ArticleObject.self, forPrimaryKey: article.articleUrl)
            article.saved = savedArticle != nil ? true: false
            
            cell.delegate = self
            cell.indexPath = indexPath
            cell.title.text = article.title
            cell.articleDescription.text = article.articleDescription
            cell.publishDate.text = article.publishDate
            cell.articleButton.imageView?.image = article.saved! ? UIImage(named: "saved") : UIImage(named: "save")
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
        if indexPath.section == 0 {
            performSegue(withIdentifier: "goToArticle", sender: self)
        }
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        isLoading = true
        DispatchQueue.global().async {
            self.fetchArticles()
        }
    }
    
    func registerNibCell(nibName: String, cellId: String){
        let tableViewLoadingCellNib = UINib(nibName: nibName, bundle: nil)
        tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: cellId)
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                let page = self.articles.count / 15 + 1
                self.fetchArticles(of: page)
            }
        }
    }
    
    func updateArticleList(articleList: [Article], currentPage: Int, resultsAmount: Int) {
        refreshControl?.endRefreshing()
        if isLoading {
            isLoading = false
            updateHeadlines(articleList: articleList, currentPage: currentPage)
        }

        if let results = totalResults, resultsAmount != 0, totalResults != resultsAmount{
            isLoading = true
            let resultsDifference = resultsAmount - results
            var pageSize = resultsDifference < 0 ? resultsAmount : articles.count + resultsDifference
            if pageSize > 100 {
                pageSize = 100
            }
            fetchArticles(of: 1, with: pageSize)
        } else {
            totalResults = resultsAmount
        }
    }
    
    func updateHeadlines(articleList: [Article], currentPage: Int) {
        isEndOfList = articleList.count < 15 ? true : false
        if currentPage == 1 {
            articles = articleList
        } else {
            articles.append(contentsOf: articleList)
        }
        tableView.reloadData()
    }
    
    func fetchArticles(of page: Int = 1, with pageSize: Int = 15) {
        
    }
    
    func saveArticle(article: Article){
        do{
            try container.write {
                savedArticle in
                savedArticle.add(article)
            }
        }catch{
            print("Error saving category \(error)")
        }
    }
    
    func deleteArticle(article: ArticleObject){
        do{
            try realm.write {
                realm.delete(article)
            }
        }catch{
            print("Error deleting category \(error)")
        }
    }

}

extension PagingTableViewController: ArticleCellDelegate {
    func articleButtonPress(at indexPath: IndexPath) {
        articles[indexPath.row].saved = !articles[indexPath.row].saved!
        if articles[indexPath.row].saved! == true {
            saveArticle(article: articles[indexPath.row])
        } else {
            let articleToDelete = realm.object(ofType: ArticleObject.self, forPrimaryKey: articles[indexPath.row].articleUrl)
            if let article = articleToDelete {
                deleteArticle(article: article)
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}







