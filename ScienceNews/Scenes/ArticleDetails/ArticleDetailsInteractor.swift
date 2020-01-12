//
//  ArticleDetailsInteractor.swift
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

protocol ArticleDetailsBusinessLogic
{
  func doSomething(request: ArticleDetails.Something.Request)
}

protocol ArticleDetailsDataStore
{
  //var name: String { get set }
}

class ArticleDetailsInteractor: ArticleDetailsBusinessLogic, ArticleDetailsDataStore
{
  var presenter: ArticleDetailsPresentationLogic?
  var worker: ArticleDetailsWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: ArticleDetails.Something.Request)
  {
    worker = ArticleDetailsWorker()
    worker?.doSomeWork()
    
    let response = ArticleDetails.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
