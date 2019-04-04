//
//  PostCell.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import SDWebImage

class PostCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func update(with post: Post) {
        imageView.sd_setImage(with: URL(string: post.thumbnail))
    }
}
