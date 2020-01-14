//
//  HeadlinesTableViewCell.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/11/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit

protocol ArticleCellDelegate {
    func articleButtonPress(at indexPath: IndexPath)
}

class ArticleCell: UITableViewCell {
    var indexPath: IndexPath!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleButton: UIButton!
    
    var delegate: ArticleCellDelegate?
    
    @IBAction func onButtonPress(_ sender: UIButton) {
        delegate?.articleButtonPress(at: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articleImg.layer.cornerRadius = 10
    }
}
