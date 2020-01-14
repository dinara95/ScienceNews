//
//  SavedArticlesTableViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/14/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit
import RealmSwift

class SavedArticlesTableViewController: UITableViewController, ArticleCellDelegate {

    var realm = try! Realm()
    var savedArticles: Results<ArticleObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedArticles()
        registerNibCell(nibName: "ArticleCell", cellId: "articleCellId")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ArticleDetailsViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("No indexPath") }
        let selectedArticle = savedArticles?[indexPath.row]
        let articleStruct = Article(title: selectedArticle?.title, author: selectedArticle?.author, articleDescription: selectedArticle?.articleDescription, imageUrl: selectedArticle?.imageUrl, publishDate: selectedArticle?.publishDate, content: selectedArticle?.content, articleUrl: selectedArticle?.articleUrl, saved: selectedArticle?.saved)
        destinationVC.selectedArticle = articleStruct
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArticles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCellId", for: indexPath) as! ArticleCell
        cell.delegate = self
        cell.indexPath = indexPath
        let article = savedArticles?[indexPath.row]
        cell.title.text = article?.title
        cell.articleDescription.text = article?.articleDescription
        cell.publishDate.text = article?.publishDate
        cell.author.text = article?.author
        if let url = URL(string: article?.imageUrl ?? "") {
            cell.articleImg.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToArticle", sender: self)
    }
    
    func registerNibCell(nibName: String, cellId: String) {
        let tableViewLoadingCellNib = UINib(nibName: nibName, bundle: nil)
        tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: cellId)
    }
    
    func loadSavedArticles() {
        savedArticles = realm.objects(ArticleObject.self)
    }
    
    func deleteCategory(article: ArticleObject) {
        do {
            try realm.write {
                realm.delete(article)
            }
        } catch {
            print("Error deleting category \(error)")
        }
        tableView.reloadData()
    }
    
    func articleButtonPress(at indexPath: IndexPath) {
        if let article = savedArticles?[indexPath.row] {
            deleteCategory(article: article)
        }
    }
}
