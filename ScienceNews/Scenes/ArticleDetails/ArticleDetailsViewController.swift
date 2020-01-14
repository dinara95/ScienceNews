//
//  ArticleDetailsViewController.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/12/20.
//  Copyright (c) 2020 Dinara Shadyarova. All rights reserved.
//


import UIKit

class ArticleDetailsViewController: UIViewController {
    var selectedArticle: Article?

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleContent: UITextView!
    
    @IBAction func onUrlPress(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            guard let url = URL(string: selectedArticle?.articleUrl ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            guard let url = URL(string: selectedArticle?.articleUrl ?? "") else { return }
            UIApplication.shared.openURL(url)
        }
    }
  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTitle.text = selectedArticle?.title ?? ""
        articleDescription.text = selectedArticle?.articleDescription ?? ""
        publishDate.text = selectedArticle?.publishDate ?? ""
        if let url = URL(string: selectedArticle?.imageUrl ?? "") {
            articleImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        articleContent.text = selectedArticle?.content ?? ""
  }
}
