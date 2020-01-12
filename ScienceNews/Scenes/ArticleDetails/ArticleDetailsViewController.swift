//
//  ArticleDetailsViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/12/20.
//  Copyright (c) 2020 Dinara Shadyarova. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ArticleDetailsDisplayLogic: class
{
  func displaySomething(viewModel: ArticleDetails.Something.ViewModel)
}

class ArticleDetailsViewController: UIViewController, ArticleDetailsDisplayLogic
{
  var interactor: ArticleDetailsBusinessLogic?
  var router: (NSObjectProtocol & ArticleDetailsRoutingLogic & ArticleDetailsDataPassing)?
    
    var selectedArticle: TopHeadlines.Article?

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    
    @IBOutlet weak var publishDate: UILabel!
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var articleContent: UITextView!
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
    let interactor = ArticleDetailsInteractor()
    let presenter = ArticleDetailsPresenter()
    let router = ArticleDetailsRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    if let articles = selectedArticle {
        articleTitle.text = articles.title
        articleDescription.text = articles.description
        publishDate.text = articles.publishDate
        if let url = URL(string: articles.imageUrl ?? "") {
            articleImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        articleContent.text = articles.content
//        adjustUITextViewHeight()
    }
    
    var frame = articleContent.frame
    frame.size.height = articleContent.contentSize.height
    articleContent.frame = frame
    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = ArticleDetails.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: ArticleDetails.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    func adjustUITextViewHeight()
    {
//        articleContent.translatesAutoresizingMaskIntoConstraints = true
//        articleContent.sizeToFit()
        articleContent.isScrollEnabled = false
        articleContent.isScrollEnabled = true
        articleContent.isScrollEnabled = false
    }
}


extension ArticleDetailsViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
