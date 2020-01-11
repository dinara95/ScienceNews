//
//  HeadlinesTableViewCell.swift
//  ScienceNews
//
//  Created by Dinara Shadyarova on 1/11/20.
//  Copyright © 2020 Dinara Shadyarova. All rights reserved.
//

import UIKit

class HeadlinesTableViewCell: UITableViewCell {


    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var articleDescription: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articleImg.layer.cornerRadius = 10
    }

    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //
    //        // Configure the view for the selected state
    //    }
}
