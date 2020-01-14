//
//  Article.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/14/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

extension Article: Persistable {
    public init(managedObject: ArticleObject) {
        title = managedObject.title
        author = managedObject.author
        articleDescription = managedObject.articleDescription
        imageUrl = managedObject.imageUrl
        publishDate = managedObject.publishDate
        content = managedObject.content
        articleUrl = managedObject.articleUrl
        saved = managedObject.saved
    }
    public func managedObject() -> ArticleObject {
        let savedArticle = ArticleObject()
        savedArticle.title = title ?? ""
        savedArticle.author = author ?? ""
        savedArticle.articleDescription = articleDescription ?? ""
        savedArticle.imageUrl = imageUrl ?? ""
        savedArticle.publishDate = publishDate ?? ""
        savedArticle.content = content ?? ""
        savedArticle.articleUrl = articleUrl ?? ""
        savedArticle.saved = saved ?? false
        return savedArticle
    }
}
