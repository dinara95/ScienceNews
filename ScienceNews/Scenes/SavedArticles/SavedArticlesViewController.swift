//
//  SavedArticlesViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/13/20.
//  Copyright (c) 2020 Dinara Shadyarova. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RealmSwift

protocol SavedArticlesDisplayLogic: class
{
  func displaySomething(viewModel: SavedArticles.Something.ViewModel)
}

class SavedArticlesViewController: UITableViewController, SavedArticlesDisplayLogic, ArticleCellDelegate
{
   
    
    var realm = try! Realm()
    var savedArticles: Results<ArticleObject>?
  var interactor: SavedArticlesBusinessLogic?
  var router: (NSObjectProtocol & SavedArticlesRoutingLogic & SavedArticlesDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = SavedArticlesInteractor()
    let presenter = SavedArticlesPresenter()
    let router = SavedArticlesRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! ArticleDetailsViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("No indexPath") }
        let selectedArticle = savedArticles?[indexPath.row]
        let articleStruct = Article(title: selectedArticle?.title, author: selectedArticle?.author, description: selectedArticle?.articleDescription, imageUrl: selectedArticle?.imageUrl, publishDate: selectedArticle?.publishDate, content: selectedArticle?.content, articleUrl: selectedArticle?.articleUrl, saved: selectedArticle?.saved)
        destinationVC.selectedArticle = articleStruct
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        navigationItem.backBarButtonItem?.title = ""
        
    }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    loadSavedArticles()
    registerNibCell(nibName: "ArticleCell", cellId: "articleCellId")
    doSomething()
  }
    
    func registerNibCell(nibName: String, cellId: String){
        let tableViewLoadingCellNib = UINib(nibName: nibName, bundle: nil)
        tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: cellId)
    }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
    
    func loadSavedArticles() {
        savedArticles = realm.objects(ArticleObject.self)
    }
  
  func doSomething()
  {
    let request = SavedArticles.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: SavedArticles.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
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
        cell.articleDescription.text = article?.description
        cell.publishDate.text = article?.publishDate
        cell.articleButton.imageView?.image = UIImage(named: "saved")
        cell.author.text = article?.author
        if let url = URL(string: article?.imageUrl ?? "") {
            cell.articleImg.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        return cell
    }
    
    func deleteCategory(article: ArticleObject){
        do{
            //            try container.write {
            //                savedArticle in
            //                savedArticle.delete(article)
            //            }
            try realm.write {
                realm.delete(article)
            }
        }catch{
            print("Error deleting category \(error)")
        }
        //we dont reload tableView, because SwipeCell already does it for us
        tableView.reloadData()
    }
    
    
    func articleButtonPress(at indexPath: IndexPath) {
        if let article = savedArticles?[indexPath.row] {
            deleteCategory(article: article)
        }
    }
}
